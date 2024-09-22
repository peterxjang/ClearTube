import SwiftUI
import SwiftData

struct VideoCard: View {
    var video: VideoObject
    var width: CGFloat = 500.0

    var body: some View {
        let height = width / 1.8

        VStack(alignment: .leading) {
            NavigationLink(destination: VideoPlayer(video: video)) {
                ZStack(alignment: .bottomLeading) {
                    VideoThumbnail(width: width, height: height, radius: 8.0, thumbnail: video.videoThumbnails.preferredThumbnail(for: width))
                    VideoThumbnailTag(video.lengthSeconds)
                    VideoThumbnailWatchProgress(video: video, width: width)
                }.frame(width: width, height: height)
            }
            #if os(tvOS)
            .buttonStyle(.card)
            #endif
            .frame(width: width)
            .contextMenu {
                VideoContextMenu(video: video)
            }

            Text(video.title).lineLimit(2, reservesSpace: true).font(.headline)
            Text(video.author ?? "").lineLimit(1).foregroundStyle(.secondary).font(.caption)
            if let publishedText = video.publishedText, let viewCountText = video.viewCountText {
                Text("\(publishedText)  |  \(viewCountText)").lineLimit(1).foregroundStyle(.secondary).font(.caption)
            }
        }.frame(width: width)
    }
}

struct VideoThumbnail: View {
    let width: CGFloat
    let height: CGFloat
    let radius: CGFloat
    var thumbnail: ImageObject?

    var body: some View {
        Rectangle().foregroundStyle(.background)
            .frame(maxWidth: width, maxHeight: height)
            .aspectRatio(16 / 9, contentMode: .fill)
            .background(Rectangle().foregroundStyle(.background))
            .overlay {
                CacheAsyncImage(url: thumbnail?.getURL()) { image in
                    image.resizable().scaledToFill()
                        .frame(maxWidth: width, maxHeight: height)
                } placeholder: {}
                    .frame(maxWidth: width, maxHeight: height)
                    .clipped()
            }
            .cornerRadius(radius)
            .clipped()
    }
}

struct VideoThumbnailTag: View {
    var content: String

    init(_ content: String) {
        self.content = content
    }

    init(_ seconds: Int) {
        self.content = (Date() ..< Date().advanced(by: TimeInterval(seconds))).formatted(.timeDuration)
    }

    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Group {
                    Text(content)
                        .padding(.horizontal, 6.0)
                        .padding(.vertical, 2.0)
                        .font(.caption2)
                }
                .background(.black)
                .foregroundStyle(.white)
                .cornerRadius(4.0)
                .padding([.bottom, .trailing], 4.0)
            }
        }
    }
}

struct VideoThumbnailWatchProgress: View {
    var video: VideoObject
    var width: CGFloat
    @Query var historyVideos: [HistoryVideo]

    var body: some View {
        if let historyVideo = historyVideos.first(where: { $0.videoId == video.videoId }) {
            let progress = video.lengthSeconds > 0 ? CGFloat(historyVideo.watchedSeconds) / CGFloat(video.lengthSeconds) : 1.0
            Rectangle()
                .fill(Color(UIColor.lightGray))
                .frame(width: width, height: 5)
            Rectangle()
                .fill(Color.red)
                .frame(width: width * progress, height: 5)
        }
    }
}

struct VideoContextMenu: View {
    var video: VideoObject
    @Environment(\.modelContext) private var context
    @Query var watchLaterVideos: [WatchLaterVideo]

    var body: some View {
        if let authorId = video.authorId {
            NavigationLink(destination: ChannelView(channelId: authorId)) {
                Label("Go to channel", systemImage: "location.circle")
            }
        }

        let isInWatchLater = watchLaterVideos.contains(where: { $0.videoId == video.videoId })
        if isInWatchLater {
            Button {
                removeFromWatchLater()
            } label: {
                Label("Remove from Watch Later", systemImage: "minus.circle")
            }
        } else {
            Button {
                addToWatchLater()
            } label: {
                Label("Add to Watch Later", systemImage: "plus.circle")
            }
        }
    }

    private func removeFromWatchLater() {
        if let index = watchLaterVideos.firstIndex(where: { $0.videoId == video.videoId }) {
            context.delete(watchLaterVideos[index])
        }
    }

    private func addToWatchLater() {
        let savedVideo = WatchLaterVideo(video: video)
        context.insert(savedVideo)
    }
}
