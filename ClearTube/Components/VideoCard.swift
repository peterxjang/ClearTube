import SwiftUI

struct VideoCard: View {
    var video: VideoObject

    var body: some View {
        let width = 500.0
        let height = width / 1.8

        VStack(alignment: .leading) {
            ZStack(alignment: .bottomLeading) {
                VideoThumbnail(width: width, height: height, radius: 8.0, thumbnails: video.videoThumbnails)
                VideoThumbnailTag(lengthSeconds: video.lengthSeconds)
            }.frame(width: width, height: height)
            Text(video.title).lineLimit(2, reservesSpace: true).font(.headline)
            Text(video.author).lineLimit(1).foregroundStyle(.secondary).font(.caption)
            if let viewCountTextValue = video.viewCountText {
                Text("\(video.publishedText)  |  \(viewCountTextValue)").lineLimit(1).foregroundStyle(.secondary).font(.caption)
            }
        }.frame(width: width)
    }
}
