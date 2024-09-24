import Foundation

struct PlayerResponse: Decodable {
    var streamingData: StreamingData
    struct StreamingData: Decodable {
        var hlsManifestUrl: String
        var adaptiveFormats: [AdaptiveFormats]
        struct AdaptiveFormats: Decodable {
            var url: String
            var mimeType: String
            var bitrate: Int
            var width: Int?
            var height: Int?
        }
    }
    var videoDetails: VideoDetails
    struct VideoDetails: Decodable {
        var videoId: String
        var title: String
        var lengthSeconds: String
        var viewCount: String
        var author: String
        var channelId: String
        var thumbnail: Thumbnail
        struct Thumbnail: Decodable {
            var thumbnails: [ImageObject]
        }
    }
}
