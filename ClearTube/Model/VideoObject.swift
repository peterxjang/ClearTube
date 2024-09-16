import Foundation

public struct VideoObject: Equatable, Decodable {
    public var title: String
    public var videoId: String
    public var lengthSeconds: Int
    public var videoThumbnails: [ImageObject]
    public var description: String?
    public var published: Int64?
    public var publishedText: String?
    public var viewCount: Int64?
    public var viewCountText: String?
    public var author: String?
    public var authorId: String?
    public var authorUrl: String?
    public var hlsUrl: String?
    public var adaptiveFormats: [AdaptiveFormatObject]?
    public var formatStreams: [FormatStreamObject]?
    public var captions: [CaptionObject]?
    public var recommendedVideos: [RecommendedVideoObject]?

    public struct AdaptiveFormatObject: Decodable {
        public var index: String
        public var bitrate: String
        public var `init`: String
        public var url: String
        public var itag: String
        public var type: String
        public var clen: String
        public var lmt: String
        public var projectionType: String
        public var container: String?
        public var encoding: String?
        public var qualityLabel: String?
        public var resolution: String?
    }

    public struct FormatStreamObject: Decodable {
        public var url: String
        public var itag: String
        public var type: String
        public var quality: String
        public var container: String
        public var encoding: String
        public var qualityLabel: String
        public var resolution: String
        public var size: String
    }

    public struct CaptionObject: Decodable {
        public var label: String
        public var languageCode: String?
        public var url: String
    }

    public struct RecommendedVideoObject: Decodable {
        public var videoId: String
        public var title: String
        public var lengthSeconds: Int
        public var videoThumbnails: [ImageObject]
        public var author: String?
        public var authorId: String?
        public var viewCount: Int64?
        public var viewCountText: String?
    }

    public static func == (lhs: VideoObject, rhs: VideoObject) -> Bool {
        lhs.videoId == rhs.videoId
    }
}
