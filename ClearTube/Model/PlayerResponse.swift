import Foundation

struct PlayerResponse: Decodable {
    var streamingData: StreamingDataResponse
    struct StreamingDataResponse: Decodable {
        var hlsManifestUrl: String
        var adaptiveFormats: [StreamingDataAdaptiveFormatObject]
        struct StreamingDataAdaptiveFormatObject: Decodable {
            var url: String
            var mimeType: String
            var bitrate: Int
            var width: Int?
            var height: Int?
        }
    }
    var videoDetails: VideoDetailsResponse
    struct VideoDetailsResponse: Decodable {
        var videoId: String
        var title: String
        var lengthSeconds: String
        var viewCount: String
        var author: String
        var channelId: String
        var thumbnail: ThumbnailsResponse
        struct ThumbnailsResponse: Decodable {
            var thumbnails: [ImageObject]
        }
    }
}
