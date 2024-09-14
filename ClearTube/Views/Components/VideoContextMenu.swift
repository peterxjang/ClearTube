import SwiftUI
import SwiftData

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
