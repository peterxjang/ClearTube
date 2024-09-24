import Foundation
import SwiftData

@Model
class HistoryVideo {
    @Attribute(.unique) var videoId: String
    var title: String
    var lengthSeconds: Int
    var watchedSeconds: Double
    var thumbnailUrl: String?
    var thumbnailWidth: Int?
    var thumbnailHeight: Int?
    var author: String?
    var authorId: String?
    var published: Int64?
    var viewCountText: String?

    init(video: VideoObject, watchedSeconds: Double) {
        let thumbnail = video.videoThumbnails.preferredThumbnail()
        self.videoId = video.videoId
        self.title = video.title
        self.lengthSeconds = video.lengthSeconds
        self.watchedSeconds = watchedSeconds
        self.thumbnailUrl = thumbnail?.url
        self.thumbnailWidth = thumbnail?.width
        self.thumbnailHeight = thumbnail?.height
        self.author = video.author
        self.authorId = video.authorId
        self.published = video.published
        self.viewCountText = video.viewCountText
    }
}
