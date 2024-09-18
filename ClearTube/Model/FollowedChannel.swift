import Foundation
import SwiftData

@Model
class FollowedChannel {
    @Attribute(.unique) var authorId: String
    var author: String
    var authorUrl: String
    var thumbnailUrl: String?
    var thumbnailWidth: Int?
    var thumbnailHeight: Int?
    var subCount: Int?
    var subCountText: String?
    var dateFollowed: Date = Date()

    init(channel: ChannelObject) {
        let thumbnail = channel.authorThumbnails.preferredThumbnail()
        self.authorId = channel.authorId
        self.author = channel.author
        self.authorUrl = channel.authorUrl
        self.thumbnailUrl = thumbnail?.url
        self.thumbnailWidth = thumbnail?.width
        self.thumbnailHeight = thumbnail?.height
        self.subCount = channel.subCount
        self.subCountText = channel.subCountText
        self.dateFollowed = dateFollowed
    }
}
