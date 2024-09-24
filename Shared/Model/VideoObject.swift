import Foundation

public struct VideoObject: Equatable, Decodable {
    public var title: String
    public var videoId: String
    public var lengthSeconds: Int
    public var videoThumbnails: [ImageObject]
    public var description: String?
    public var published: Int64?
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
        public var published: Int64?
        public var viewCountText: String?
    }

    public static func == (lhs: VideoObject, rhs: VideoObject) -> Bool {
        lhs.videoId == rhs.videoId
    }

    init(
        title: String,
        videoId: String,
        lengthSeconds: Int,
        videoThumbnails: [ImageObject],
        description: String? = nil,
        published: Int64? = nil,
        viewCountText: String? = nil,
        author: String? = nil,
        authorId: String? = nil,
        authorUrl: String? = nil,
        hlsUrl: String? = nil,
        adaptiveFormats: [AdaptiveFormatObject]? = nil,
        formatStreams: [FormatStreamObject]? = nil,
        captions: [CaptionObject]? = nil,
        recommendedVideos: [RecommendedVideoObject]? = nil
    ) {
        self.title = title
        self.videoId = videoId
        self.lengthSeconds = lengthSeconds
        self.videoThumbnails = videoThumbnails
        self.description = description
        self.published = published
        self.viewCountText = viewCountText
        self.author = author
        self.authorId = authorId
        self.authorUrl = authorUrl
        self.hlsUrl = hlsUrl
        self.adaptiveFormats = adaptiveFormats
        self.formatStreams = formatStreams
        self.captions = captions
        self.recommendedVideos = recommendedVideos
    }

    init(for watchLaterVideo: WatchLaterVideo) {
        self.title = watchLaterVideo.title
        self.videoId = watchLaterVideo.videoId
        self.lengthSeconds = watchLaterVideo.lengthSeconds
        self.videoThumbnails = [
            ImageObject(
                url: watchLaterVideo.thumbnailUrl ?? "",
                width: watchLaterVideo.thumbnailWidth ?? 0,
                height: watchLaterVideo.thumbnailHeight ?? 0
            )
        ]
        self.published = watchLaterVideo.published
        self.viewCountText = watchLaterVideo.viewCountText
        self.author = watchLaterVideo.author
        self.authorId = watchLaterVideo.authorId
    }

    init(for recommendedVideo: RecommendedVideo) {
        self.title = recommendedVideo.title
        self.videoId = recommendedVideo.videoId
        self.lengthSeconds = recommendedVideo.lengthSeconds
        self.videoThumbnails = [
            ImageObject(
                url: recommendedVideo.thumbnailUrl ?? "",
                width: recommendedVideo.thumbnailWidth ?? 0,
                height: recommendedVideo.thumbnailHeight ?? 0
            )
        ]
        self.published = recommendedVideo.published
        self.viewCountText = recommendedVideo.viewCountText
        self.author = recommendedVideo.author
        self.authorId = recommendedVideo.authorId
    }

    init(for historyVideo: HistoryVideo) {
        self.title = historyVideo.title
        self.videoId = historyVideo.videoId
        self.lengthSeconds = historyVideo.lengthSeconds
        self.videoThumbnails = [
            ImageObject(
                url: historyVideo.thumbnailUrl ?? "",
                width: historyVideo.thumbnailWidth ?? 0,
                height: historyVideo.thumbnailHeight ?? 0
            )
        ]
        self.published = historyVideo.published
        self.viewCountText = historyVideo.viewCountText
        self.author = historyVideo.author
        self.authorId = historyVideo.authorId
    }
}
