import Foundation

public final class InnerTubeAPI {
    let baseUrl: URL? = URL(string: "https://youtubei.googleapis.com")
    var session: URLSession
    static var decoder = JSONDecoder()

    public struct PlayerResponseObject: Decodable {
        public var streamingData: StreamingDataObject
        public var videoDetails: VideoDetailsObject
    }

    public struct StreamingDataObject: Decodable {
        public var hlsManifestUrl: String
        public var adaptiveFormats: [StreamingDataAdaptiveFormatObject]
    }

    public struct StreamingDataAdaptiveFormatObject: Decodable {
        public var url: String
        public var mimeType: String
        public var bitrate: Int
        public var width: Int?
        public var height: Int?
    }

    public struct VideoDetailsObject: Decodable {
        public var videoId: String
        public var title: String
        public var lengthSeconds: String
        public var viewCount: String
        public var author: String
        public var thumbnail: ThumbnailsObject
    }

    public struct ThumbnailsObject: Decodable {
        public var thumbnails: [ImageObject]
    }

    struct RequestBody: Codable {
        let context: Context
    }

    struct Context: Codable {
        let client: Client
        let user: User
        let request: RequestContext
    }

    struct Client: Codable {
        let clientName: String
        let clientVersion: String
        let hl: String
        let gl: String
        let deviceMake: String?
        let deviceModel: String?
        let experimentIds: [String]
        let utcOffsetMinutes: Int
    }

    struct User: Codable {
        let lockedSafetyMode: Bool
    }

    struct RequestContext: Codable {
        let useSsl: Bool
        let internalExperimentFlags: [String]
        let consistencyTokenJars: [String]
    }

    public init(session: URLSession = .shared) {
        self.session = session
    }

    func requestUrl(for string: String, with queryItems: [URLQueryItem]? = nil) -> URL? {
        guard var url = URL(string: string, relativeTo: baseUrl) else {
            return nil
        }
        if let queryItems = queryItems {
            if #available(iOS 16, macOS 13, tvOS 16, *) {
                url.append(queryItems: queryItems)
            } else {
                guard var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
                    return nil
                }
                components.queryItems = queryItems
                return components.url
            }
        }
        return url
    }

    func request(for string: String, with queryItems: [URLQueryItem]? = nil) async throws -> (Data, URLResponse) {
        guard let url = requestUrl(for: string, with: queryItems) else {
            throw APIError.urlCreation
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.157 Safari/537.36", forHTTPHeaderField: "User-Agent")
        request.addValue("1", forHTTPHeaderField: "X-YouTube-Client-Name")
        request.addValue("2.20230728.00.00", forHTTPHeaderField: "X-YouTube-Client-Version")
        request.httpBody = try JSONEncoder().encode(
            RequestBody(
                context: Context(
                    client: Client(
                        clientName: "IOS",
                        clientVersion: "19.16.3",
                        hl: "en",
                        gl: "US",
                        deviceMake: "Apple",
                        deviceModel: "iPhone",
                        experimentIds: [],
                        utcOffsetMinutes: 0
                    ),
                    user: User(lockedSafetyMode: false),
                    request: RequestContext(
                        useSsl: true,
                        internalExperimentFlags: [],
                        consistencyTokenJars: []
                    )
                )
            )
        )
        return try await session.data(for: request)
    }

    func video(for id: String) async throws -> VideoObject {
        guard let idPath = id.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            throw APIError.urlCreation
        }
        do {
            let (data, _) = try await request(
                for: "/youtubei/v1/player",
                with: [URLQueryItem(name: "videoId", value: idPath)]
            )
            let json = try Self.decoder.decode(PlayerResponseObject.self, from: data)
            print(json)
            return VideoObject(
                title: json.videoDetails.title,
                videoId: json.videoDetails.videoId,
                lengthSeconds: Int(json.videoDetails.lengthSeconds) ?? 0,
                videoThumbnails: json.videoDetails.thumbnail.thumbnails,
                author: json.videoDetails.author,
                hlsUrl: json.streamingData.hlsManifestUrl
            )
        } catch {
            print("An error occurred: \(error.localizedDescription)")
            print("Error details: \(error)")
            throw error
        }
    }

    func search(query: String, page: Int32) async throws -> [SearchObject.Result] {
        let (data, _) = try await request(
            for: "/youtubei/v1/search",
            with: [URLQueryItem(name: "query", value: query)]
        )
        return try Self.decoder.decode([SearchObject.Result].self, from: data)
    }
}
