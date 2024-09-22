import Foundation

public struct SearchObject {
    public struct Suggestions: Decodable {
        public var query: String
        public var suggestions: [String]
    }

    public enum Result: Decodable, Identifiable {
        case video(VideoObject)
        case channel(ChannelObject)
        case playlist(PlaylistObject)

        public var id: String {
            switch self {
            case .video(let data):
                return data.videoId
            case .channel(let data):
                return data.authorId
            case .playlist(let data):
                return data.playlistId
            }
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let response = try? container.decode(VideoObject.self) {
                self = .video(response)
            } else if let response = try? container.decode(ChannelObject.self) {
                self = .channel(response)
            } else if let response = try? container.decode(PlaylistObject.self) {
                self = .playlist(response)
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot initialize Result")
            }
        }

        public init(from video: VideoObject) {
            self = .video(video)
        }

        public init(from channel: ChannelObject) {
            self = .channel(channel)
        }
    }
}
