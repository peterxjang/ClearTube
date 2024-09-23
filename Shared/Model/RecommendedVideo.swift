import Foundation
import SwiftData

@Model
class RecommendedVideo {
    @Attribute(.unique) var videoId: String
    var title: String
    var lengthSeconds: Int
    var thumbnailUrl: String?
    var thumbnailWidth: Int?
    var thumbnailHeight: Int?
    var author: String?
    var authorId: String?
    var published: Int64?
    var viewCount: Int64?

    init(recommendedVideo: VideoObject.RecommendedVideoObject) {
        let thumbnail = recommendedVideo.videoThumbnails.preferredThumbnail()
        self.videoId = recommendedVideo.videoId
        self.title = recommendedVideo.title
        self.lengthSeconds = recommendedVideo.lengthSeconds
        self.thumbnailUrl = thumbnail?.url
        self.thumbnailWidth = thumbnail?.width
        self.thumbnailHeight = thumbnail?.height
        self.author = recommendedVideo.author
        self.authorId = recommendedVideo.authorId
        self.published = recommendedVideo.published
        self.viewCount = recommendedVideo.viewCount
    }
}
