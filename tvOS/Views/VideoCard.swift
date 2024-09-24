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
            .buttonStyle(.card)
            .frame(width: width)
            .contextMenu {
                VideoContextMenu(video: video)
            }

            Text(video.title).lineLimit(2, reservesSpace: true).font(.headline)
            Text(video.author ?? "").lineLimit(1).foregroundStyle(.secondary).font(.caption)
            if let published = video.published, let viewCountText = video.viewCountText {
                Text("\(Helper.timeAgo(from: published))  |  \(viewCountText)").lineLimit(1).foregroundStyle(.secondary).font(.caption)
            }
        }.frame(width: width)
    }
}
