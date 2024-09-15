import Foundation
import SwiftData

@Model
class FollowedChannel {
    @Attribute(.unique) var authorId: String
    var author: String
    var authorUrl: String
    var thumbnailUrl: String
    var subCount: Int
    var dateFollowed: Date = Date()

    init(
        authorId: String,
        author: String,
        authorUrl: String,
        thumbnailUrl: String,
        subCount: Int,
        dateFollowed: Date
    ) {
        self.authorId = authorId
        self.author = author
        self.authorUrl = authorUrl
        self.thumbnailUrl = thumbnailUrl
        self.subCount = subCount
        self.dateFollowed = dateFollowed
    }
}
