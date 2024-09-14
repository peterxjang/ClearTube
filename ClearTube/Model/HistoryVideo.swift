import Foundation
import SwiftData

@Model
class HistoryVideo {
    @Attribute(.unique) var videoId: String
    var title: String
    var author: String
    var authorId: String
    var published: Int64
    var lengthSeconds: Int
    var thumbnailQuality: String
    var thumbnailUrl: String
    var thumbnailWidth: Int
    var thumbnailHeight: Int
    var viewCountText: String
    var watchedSeconds: Double

    init(videoId: String, title: String, author: String, authorId: String, published: Int64, lengthSeconds: Int, viewCountText: String, thumbnailQuality: String, thumbnailUrl: String, thumbnailWidth: Int, thumbnailHeight: Int, watchedSeconds: Double) {
        self.videoId = videoId
        self.title = title
        self.author = author
        self.authorId = authorId
        self.published = published
        self.lengthSeconds = lengthSeconds
        self.viewCountText = viewCountText
        self.thumbnailQuality = thumbnailQuality
        self.thumbnailUrl = thumbnailUrl
        self.thumbnailWidth = thumbnailWidth
        self.thumbnailHeight = thumbnailHeight
        self.watchedSeconds = watchedSeconds
    }
}
