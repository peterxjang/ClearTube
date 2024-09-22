import SwiftUI
import SwiftData

struct FeedView: View {
    @State private var isLoading: Bool = true
    @State private var videos: [VideoObject] = []
    @State private var loadedChannelsCount: Int = 0
    @State private var hasLoadedOnce: Bool = false
    @Query(sort: \FollowedChannel.author) var channels: [FollowedChannel]
    
    var body: some View {
        GeometryReader { geometry in
            let minWidth: CGFloat = 250
            let screenWidth = geometry.size.width
            let columns = Int(screenWidth / minWidth)
            let spacing: CGFloat = screenWidth / 20.0
            let width = (screenWidth - CGFloat(columns - 1) * spacing) / CGFloat(columns)

            ScrollView {
                if channels.isEmpty {
                    MessageBlock(
                        title: "You aren't following any channels.",
                        message: "Search for channels you'd like to follow."
                    ).padding(.horizontal)
                } else {
                    VStack(alignment: .trailing) {
                        if isLoading {
                            ProgressView(value: Double(loadedChannelsCount), total: Double(channels.count))
                                .padding()
                            Text("Loaded \(loadedChannelsCount) out of \(channels.count) channels")
                                .padding()
                        } else {
                            Button {
                                loadedChannelsCount = 0
                                isLoading = true
                                Task {
                                    await fetchVideos()
                                }
                            } label: {
                                Label("Refresh", systemImage: "arrow.clockwise")
                            }
                            .padding(.trailing, 20)
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: spacing), count: columns), spacing: spacing) {
                                ForEach(videos, id: \.videoId) { video in
                                    VideoCard(video: video, width: width)
                                }
                            }
                        }
                    }
                    .onAppear {
                        if !hasLoadedOnce {
                            Task {
                                await fetchVideos()
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func fetchVideos() async {
        do {
            var allVideos: [VideoObject] = []
            let oneMonthAgo = Date().addingTimeInterval(-30 * 24 * 60 * 60)
            try await withThrowingTaskGroup(of: [VideoObject].self) { group in
                for channel in channels {
                    group.addTask {
                        let result: ChannelObject.VideosResponse
                        do {
                            result = try await ClearTubeApp.invidiousClient.videos(for: channel.authorId, continuation: nil)
                        } catch {
                            print("InvidiousClient failed for \(channel.author), trying InnerTubeClient")
                            try await Task.sleep(nanoseconds: UInt64.random(in: 0_000_000_000..<5_000_000_000))
                            result = try await ClearTubeApp.innerTubeClient.videos(for: channel.authorId, continuation: nil)
                        }
                        let recentVideos = result.videos.filter { video in
                            let publishedDate = Date(timeIntervalSince1970: TimeInterval(video.published ?? 0))
                            return publishedDate >= oneMonthAgo
                        }
                        return recentVideos
                    }
                }
                for try await recentVideos in group {
                    allVideos.append(contentsOf: recentVideos)
                    loadedChannelsCount += 1
                    videos = allVideos.sorted(by: { $0.published ?? 0 > $1.published ?? 0 })
                }
            }
            isLoading = false
            hasLoadedOnce = true
        } catch {
            print("Error fetching videos: \(error)")
            isLoading = false
        }
    }
}
