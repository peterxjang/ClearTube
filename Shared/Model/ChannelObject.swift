import Foundation

public enum ResultType: String, Decodable {
    case video
    case short
    case channel
    case playlist
}

public struct ChannelObject: Decodable {
    public var author: String
    public var authorId: String
    public var authorUrl: String
    public var authorThumbnails: [ImageObject]
    public var subCount: Int?
    public var subCountText: String?
    public var description: String?
    public var descriptionHtml: String?
    public var totalViews: Int?
    public var joined: Int?
    public var isFamilyFriendly: Bool?
    public var authorBanners: [ImageObject]?
    public var allowedRegions: [String]?
    public var latestVideos: [VideoObject]?
    public var relatedChannels: [ChannelObject]?
    
    public static func == (lhs: ChannelObject, rhs: ChannelObject) -> Bool {
        lhs.authorId == rhs.authorId
    }

    func subCountTextDisplay() -> String {
        return self.subCountText ?? "\((self.subCount ?? 0).formatted()) subscribers"
    }

    public struct PlaylistResponse: Decodable {
        public var playlists: [PlaylistObject]
        public var continuation: String?

        public static func == (lhs: ChannelObject.PlaylistResponse, rhs: ChannelObject.PlaylistResponse) -> Bool {
            lhs.continuation == rhs.continuation
        }

        public init(from playlists: [PlaylistObject]) {
            self.playlists = playlists
        }
    }

    public struct VideosResponse: Decodable {
        public var videos: [VideoObject]
        public var continuation: String?

        public static func == (lhs: ChannelObject.VideosResponse, rhs: ChannelObject.VideosResponse) -> Bool {
            lhs.continuation == rhs.continuation
        }

        enum CodingKeys: CodingKey {
            case videos
            case continuation
        }

        public init(from decoder: Decoder) throws {
            let container: KeyedDecodingContainer<ChannelObject.VideosResponse.CodingKeys> = try decoder.container(keyedBy: ChannelObject.VideosResponse.CodingKeys.self)
            self.continuation = try container.decodeIfPresent(String.self, forKey: ChannelObject.VideosResponse.CodingKeys.continuation)
            self.videos = (try? container.decode([VideoObject].self, forKey: ChannelObject.VideosResponse.CodingKeys.videos))
                ?? []
        }

        public init(from videos: [VideoObject]) {
            self.videos = videos
        }
    }
}
