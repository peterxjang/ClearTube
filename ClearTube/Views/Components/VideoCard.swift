import SwiftUI
import SwiftData

struct VideoCard: View {
    var video: VideoObject

    var body: some View {
        let width = 500.0
        let height = width / 1.8

        VStack(alignment: .leading) {
            NavigationLink(destination: VideoPlayer(videoId: video.videoId)) {
                ZStack(alignment: .bottomLeading) {
                    VideoThumbnail(width: width, height: height, radius: 8.0, thumbnails: video.videoThumbnails)
                    VideoThumbnailTag(video.lengthSeconds)
                    VideoThumbnailWatchProgress(video: video, width: width)
                }.frame(width: width, height: height)
            }
            .buttonStyle(.card)
            .frame(width: width)
            .contextMenu {
                VideoContextMenu(video: video)
            }

            Text(video.title).lineLimit(2, reservesSpace: true).font(.headline)
            Text(video.author ?? "(no author)").lineLimit(1).foregroundStyle(.secondary).font(.caption)
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
    var thumbnails: [ImageObject]

    var preferredThumbnail: ImageObject? {
        thumbnails
            .sorted { $0.width <= $1.width }
            .first { $0.width >= Int(width) }
    }

    var body: some View {
        Rectangle().foregroundStyle(.background)
            .frame(maxWidth: width, maxHeight: height)
            .aspectRatio(16 / 9, contentMode: .fill)
            .background(Rectangle().foregroundStyle(.background))
            .overlay {
                if let thumbnailUrl = preferredThumbnail?.url, let url = URL(string: thumbnailUrl) {
                    CacheAsyncImage(url: url) { image in
                        image.resizable().scaledToFill()
                            .frame(maxWidth: width, maxHeight: height)
                    } placeholder: {}
                        .frame(maxWidth: width, maxHeight: height)
                        .clipped()
                }
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
            let progress = CGFloat(historyVideo.watchedSeconds) / CGFloat(video.lengthSeconds)
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
            NavigationLink(destination: ChannelView(model: ChannelViewModel(channelId: authorId))) {
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
        let savedVideo = WatchLaterVideo(
            videoId: video.videoId,
            title: video.title,
            author: video.author ?? "(no author)",
            authorId: video.authorId ?? "(no author id)",
            published: video.published ?? 0,
            lengthSeconds: video.lengthSeconds,
            viewCountText: video.viewCountText ?? "0",
            thumbnailQuality: video.videoThumbnails[0].quality ?? "none",
            thumbnailUrl: video.videoThumbnails[0].url,
            thumbnailWidth: video.videoThumbnails[0].width,
            thumbnailHeight: video.videoThumbnails[0].height
        )
        context.insert(savedVideo)
    }
}
