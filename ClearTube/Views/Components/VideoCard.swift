import SwiftUI

struct VideoCard: View {
    var video: VideoObject

    var body: some View {
        let width = 500.0
        let height = width / 1.8

        VStack(alignment: .leading) {
            NavigationLink(destination: VideoPlayer(video: video)) {
                ZStack(alignment: .bottomLeading) {
                    VideoThumbnail(width: width, height: height, radius: 8.0, thumbnails: video.videoThumbnails)
                    VideoThumbnailTag(video.lengthSeconds)
                }.frame(width: width, height: height)
            }
            .buttonStyle(.card)
            .frame(width: width)

            Text(video.title).lineLimit(2, reservesSpace: true).font(.headline)
            Text(video.author ?? "(no author)").lineLimit(1).foregroundStyle(.secondary).font(.caption)
            if let publishedText = video.publishedText, let viewCountText = video.viewCountText {
                Text("\(publishedText)  |  \(viewCountText)").lineLimit(1).foregroundStyle(.secondary).font(.caption)
            }
        }.frame(width: width)
    }
}
