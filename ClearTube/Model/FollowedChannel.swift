import Foundation
import SwiftData

@Model
class FollowedChannel {
    @Attribute(.unique) var authorId: String
    var author: String
    var authorUrl: String
    var thumbnailUrl: String
    var subCount: Int?
    var subCountText: String?
    var dateFollowed: Date = Date()

    init(channel: ChannelObject) {
        self.authorId = channel.authorId
        self.author = channel.author
        self.authorUrl = channel.authorUrl
        self.thumbnailUrl = channel.authorThumbnails.preferredThumbnail()?.url ?? ""
        self.subCount = channel.subCount
        self.subCountText = channel.subCountText
        self.dateFollowed = dateFollowed
    }
}
