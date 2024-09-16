import Foundation
import SwiftData

@Model
class WatchLaterVideo {
    @Attribute(.unique) var videoId: String
    var title: String
    var lengthSeconds: Int
    var thumbnailUrl: String?
    var thumbnailWidth: Int?
    var thumbnailHeight: Int?
    var author: String?
    var authorId: String?
    var published: Int64?
    var publishedText: String?
    var viewCount: Int64?
    var viewCountText: String?

    init(video: VideoObject) {
        let thumbnail = video.videoThumbnails.preferredThumbnail()
        self.videoId = video.videoId
        self.title = video.title
        self.lengthSeconds = video.lengthSeconds
        self.thumbnailUrl = thumbnail?.url
        self.thumbnailWidth = thumbnail?.width
        self.thumbnailHeight = thumbnail?.height
        self.author = video.author
        self.authorId = video.authorId
        self.published = video.published
        self.publishedText = video.publishedText
        self.viewCount = video.viewCount
        self.viewCountText = video.viewCountText
    }
}
