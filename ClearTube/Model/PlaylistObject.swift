import Foundation

public struct PlaylistObject: Equatable, Decodable {
    public var type = ResultType.playlist
    public var title: String
    public var playlistId: String
    public var playlistThumbnail: String?
    public var author: String
    public var authorId: String
    public var videoCount: Int
    public var videos: [VideoObject]

    public static func == (lhs: PlaylistObject, rhs: PlaylistObject) -> Bool {
        lhs.playlistId == rhs.playlistId
    }
}
