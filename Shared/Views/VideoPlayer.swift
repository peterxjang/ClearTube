import SwiftUI
import SwiftData
import AVKit
import MediaPlayer
import Combine

enum VideoPlaybackError: LocalizedError {
    case missingUrl
}

struct VideoPlayer: View {
    var video: VideoObject
    var saveRecommendations: Bool = false
    @State var currentVideo: VideoObject? = nil
    @State var isLoading: Bool = true
    @State var player: AVPlayer? = nil
    @State var statusObserver: AnyCancellable?
    @State var skippableSegments: [[Float]] = []
    @Query var historyVideos: [HistoryVideo]
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        if isLoading {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                ProgressView()
                    .tint(.gray)
                    .onAppear {
                        Task {
                            let startTime = historyVideos.first(where: { $0.videoId == video.videoId })?.watchedSeconds
                            try? await playVideo(video: video, startTime: startTime)
                        }
                    }
                    .onDisappear {
                        if isLoading {
                            close()
                        }
                    }
            }
        } else {
            if let player = player, let currentVideo = currentVideo {
                VideoPlayerView(
                    video: currentVideo,
                    player: player,
                    skippableSegments: skippableSegments,
                    saveRecommendations: saveRecommendations
                )
                    .ignoresSafeArea()
                    .onDisappear {
                        close()
                    }
            } else {
                Text("Error: could not load the video")
                    .font(.headline)
                    .fontWeight(.medium)
                Button("Go back") {
                    dismiss()
                }
            }
        }
    }

    public func close() {
        player?.pause()
        player = nil
        statusObserver?.cancel()
        statusObserver = nil
    }

    private func playVideo(video: VideoObject, startTime: Double? = nil) async throws {
        async let videoTask = ClearTubeApp.innerTubeClient.video(for: video.videoId, viewCountText: video.viewCountText, published: video.published)
        async let sponsorSegmentsTask = SponsorBlockAPI.sponsorSegments(id: video.videoId)
        do {
            let (video, segments) = try await (videoTask, sponsorSegmentsTask)
            skippableSegments = segments
            let playerItem = try await createPlayerItem(for: video)
            player = AVPlayer(playerItem: playerItem)
            player?.allowsExternalPlayback = true
            statusObserver = playerItem.publisher(for: \.status)
                .sink { [self] status in
                    switch status {
                    case .readyToPlay:
                        if let startTime = startTime {
                            let newStartTime = Double(video.lengthSeconds) - startTime > 5 ? startTime : 0.0
                            self.player?.seek(to: CMTime(seconds: newStartTime, preferredTimescale: 600))
                        }
                        self.player?.play()
                        self.isLoading = false
                        self.currentVideo = video
                    case .failed:
                        self.isLoading = false
                    default:
                        break
                    }
                }
        } catch {
            isLoading = false
            return
        }
    }

    private func createPlayerItem(for video: VideoObject) async throws -> AVPlayerItem {
        let sortedStreams = video.formatStreams?.sorted {
            let aQuality = Int($0.quality.trimmingCharacters(in: .letters)) ?? -1
            let bQuality = Int($1.quality.trimmingCharacters(in: .letters)) ?? -1
            return aQuality > bQuality
        }
        if let hlsUrlStr = video.hlsUrl, let hlsUrl = URL(string: hlsUrlStr) {
            return AVPlayerItem(url: hlsUrl)
        } else if let stream = sortedStreams?.first, let streamUrl = URL(string: stream.url) {
            return AVPlayerItem(url: streamUrl)
        } else {
            throw VideoPlaybackError.missingUrl
        }
    }
}

struct VideoPlayerView: UIViewControllerRepresentable {
    var video: VideoObject
    var player: AVPlayer
    var skippableSegments: [[Float]]
    var saveRecommendations: Bool = false
    @State private var lastRate: Float = 1.0
    @Environment(\.modelContext) private var databaseContext
    @Environment(\.presentationMode) var presentationMode
    @Query var historyVideos: [HistoryVideo]
    @Query var recommendedVideos: [RecommendedVideo]

    typealias NSViewControllerType = AVPlayerViewController

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let videoView = AVPlayerViewController()
        videoView.player = player
        videoView.player?.play()
        videoView.allowsPictureInPicturePlayback = false
        videoView.player?.rate = 1.0
        #if os(tvOS)
        videoView.appliesPreferredDisplayCriteriaAutomatically = false
        let defaultSpeedImage = UIImage(systemName: "forward.circle")
        let fasterSpeedImage = UIImage(systemName: "forward.circle.fill")
        let fastestSpeedImage = UIImage(systemName: "forward.fill")
        let rateAction = UIAction(title: "Playback speed", image: defaultSpeedImage) { action in
            if player.rate == 1.0 {
                player.rate = 1.5
                action.image = fasterSpeedImage
            } else if player.rate == 1.5 {
                player.rate = 2.0
                action.image = fastestSpeedImage
            } else {
                player.rate = 1.0
                action.image = defaultSpeedImage
            }
            lastRate = player.rate
        }
        videoView.transportBarCustomMenuItems = [rateAction]
        #endif
        updateNowPlayingInfo(with: video)
        var metadata: [AVMetadataItem] = []
        metadata.append(makeMetadataItem(.commonIdentifierTitle, value: video.title))
        metadata.append(makeMetadataItem(.iTunesMetadataTrackSubTitle, value: video.author ?? "(no author)"))
        if let description = video.description {
            metadata.append(makeMetadataItem(.commonIdentifierDescription, value: description))
        }
        if let item = videoView.player?.currentItem {
            item.externalMetadata = metadata
            #if os(tvOS)
            item.navigationMarkerGroups = makeNavigationMarkerGroups(video: video)
            #endif
        }
        context.coordinator.startTrackingTime(playerViewController: videoView, skippableSegments: skippableSegments)
        return videoView
    }

    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self, player: player, video: video)
    }

    class Coordinator: NSObject {
        var parent: VideoPlayerView
        var player: AVPlayer
        var video: VideoObject
        private var timeObserverToken: Any?
        private var watchedSeconds: Double = 0.0

        init(_ parent: VideoPlayerView, player: AVPlayer, video: VideoObject) {
            self.parent = parent
            self.player = player
            self.video = video
            super.init()
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(playerDidFinishPlaying),
                name: .AVPlayerItemDidPlayToEndTime,
                object: self.player.currentItem
            )
            player.addObserver(self, forKeyPath: "timeControlStatus", options: [.new, .old], context: nil)
        }

        func startTrackingTime(playerViewController: AVPlayerViewController, skippableSegments: [[Float]]) {
            if let timeObserverToken {
                player.removeTimeObserver(timeObserverToken)
            }
            let interval = CMTime(seconds: 1, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
            timeObserverToken = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
                let currentTime = CMTimeGetSeconds(time)
                self?.watchedSeconds = currentTime
                #if os(tvOS)
                for segment in skippableSegments {
                    let startTime = segment[0]
                    let endTime = segment[1]
                    if currentTime >= Double(startTime) && currentTime < Double(endTime) {
                        if playerViewController.contextualActions.isEmpty {
                            let skipAction = UIAction(title: "Skip", image: UIImage(systemName: "forward.fill")) { _ in
                                self?.player.seek(to: CMTime(seconds: Double(endTime + 1.0), preferredTimescale: 600), toleranceBefore: CMTime.zero, toleranceAfter: CMTime.positiveInfinity)
                            }
                            playerViewController.contextualActions = [skipAction]
                        }
                        return
                    }
                }
                if !playerViewController.contextualActions.isEmpty {
                    playerViewController.contextualActions = []
                }
                #endif
            }
        }

        override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
            guard keyPath == "timeControlStatus",
                  let player = object as? AVPlayer,
                  let newValue = change?[.newKey] as? Int,
                  let oldValue = change?[.oldKey] as? Int
            else { return }
            if newValue != oldValue && player.timeControlStatus == .playing {
                if player.rate == 1.0 && parent.lastRate > 1.0 {
                    player.rate = parent.lastRate
                }
            }
        }

        @objc func playerDidFinishPlaying() {
            parent.presentationMode.wrappedValue.dismiss()
        }

        deinit {
            if let timeObserverToken {
                player.removeTimeObserver(timeObserverToken)
            }
            timeObserverToken = nil
            player.removeObserver(self, forKeyPath: "timeControlStatus")
            parent.saveRecommendedVideos(video: video)
            parent.saveVideoToHistory(video: video, watchedSeconds: watchedSeconds)
        }
    }

    private func updateNowPlayingInfo(with video: VideoObject) {
        let center = MPNowPlayingInfoCenter.default()
        center.nowPlayingInfo = [
            MPMediaItemPropertyTitle: video.title,
            MPMediaItemPropertyArtist: video.author ?? "(no author)",
        ]
    }

    #if os(tvOS)
    private func makeNavigationMarkerGroups(video: VideoObject) -> [AVNavigationMarkersGroup] {
        var metadataGroups = [AVTimedMetadataGroup]()
        if let chapters = video.chapters {
            chapters.forEach { chapter in
                metadataGroups.append(makeTimedMetadataGroup(for: chapter))
            }
        }
        return [AVNavigationMarkersGroup(title: nil, timedNavigationMarkers: metadataGroups)]
    }
    #endif

    private func makeTimedMetadataGroup(for chapter: VideoObject.ChapterObject) -> AVTimedMetadataGroup {
        var metadata = [AVMetadataItem]()
        let titleItem = makeMetadataItem(.commonIdentifierTitle, value: chapter.title)
        metadata.append(titleItem)
        if let image = UIImage(named: chapter.imageName),
           let pngData = image.pngData() {
            let imageItem = makeMetadataItem(.commonIdentifierArtwork, value: pngData)
            metadata.append(imageItem)
        }
        let timescale: Int32 = 600
        let startTime = CMTime(seconds: chapter.startTime, preferredTimescale: timescale)
        let endTime = CMTime(seconds: chapter.endTime, preferredTimescale: timescale)
        let timeRange = CMTimeRangeFromTimeToTime(start: startTime, end: endTime)
        return AVTimedMetadataGroup(items: metadata, timeRange: timeRange)
    }

    private func makeMetadataItem(_ identifier: AVMetadataIdentifier, value: Any) -> AVMetadataItem {
        let item = AVMutableMetadataItem()
        item.identifier = identifier
        item.value = value as? NSCopying & NSObjectProtocol
        item.extendedLanguageTag = "und"
        return item.copy() as! AVMetadataItem
    }

    private func saveVideoToHistory(video: VideoObject, watchedSeconds: Double) {
        guard saveRecommendations else { return }
        let context = databaseContext
        if let foundVideo = historyVideos.first(where: { $0.videoId == video.videoId }) {
            context.delete(foundVideo)
        }
        let historyVideo = HistoryVideo(video: video, watchedSeconds: watchedSeconds)
        context.insert(historyVideo)
        let maxHistorySize = 100
        let numRemove = historyVideos.count - maxHistorySize
        if numRemove > 0 {
            let videosToRemove = historyVideos.prefix(numRemove)
            for video in videosToRemove {
                context.delete(video)
            }
        }
        do {
            try context.save()
        } catch {
            print("Failed to save video to history: \(error)")
        }
    }

    private func saveRecommendedVideos(video: VideoObject) {
        guard saveRecommendations else { return }
        guard let currentRecommendedVideos = video.recommendedVideos else { return }
        guard !historyVideos.contains(where: { $0.videoId == video.videoId }) else { return }
        let context = databaseContext
        if let existingRecommendedVideo = recommendedVideos.first(where: { $0.videoId == video.videoId }) {
            context.delete(existingRecommendedVideo)
        }
        var numInserted = 0
        for recommendedVideo in currentRecommendedVideos {
            let isInRecommendations = recommendedVideos.contains(where: { $0.videoId == recommendedVideo.videoId })
            let isInHistory = historyVideos.contains(where: { $0.videoId == recommendedVideo.videoId })
            if !isInRecommendations && !isInHistory {
                let item = RecommendedVideo(recommendedVideo: recommendedVideo)
                context.insert(item)
                do {
                    try context.save()
                    numInserted += 1
                } catch {
                    print("Failed to save recommended video: \(error)")
                }
            }
            if numInserted >= 5 {
                break
            }
        }

        let maxSize = 100
        let numRemove = recommendedVideos.count - maxSize
        if numRemove > 0 {
            let videosToRemove = recommendedVideos.prefix(numRemove)
            for video in videosToRemove {
                context.delete(video)
            }
        }
    }
}
