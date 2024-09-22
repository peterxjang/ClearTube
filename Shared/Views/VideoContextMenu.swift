import SwiftUI
import SwiftData

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
