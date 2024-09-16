import Foundation

public final class InnerTubeAPI {
    let baseUrl: URL? = URL(string: "https://youtubei.googleapis.com")
    var session: URLSession
    static var decoder = JSONDecoder()

    struct PlayerResponseObject: Decodable {
        var streamingData: StreamingDataObject
        var videoDetails: VideoDetailsObject
        struct StreamingDataObject: Decodable {
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
        struct VideoDetailsObject: Decodable {
            var videoId: String
            var title: String
            var lengthSeconds: String
            var viewCount: String
            var author: String
            var channelId: String
            var thumbnail: ThumbnailsObject
            struct ThumbnailsObject: Decodable {
                var thumbnails: [ImageObject]
            }
        }
    }

    struct NextResponseObject: Decodable {
        var contents: ContentsObject
        struct ContentsObject: Decodable {
            var singleColumnWatchNextResults: SingleColumnWatchNextResultsObject
            struct SingleColumnWatchNextResultsObject: Decodable {
                var results: ResultsObject
                struct ResultsObject: Decodable {
                    var results: SubResultsObject
                    struct SubResultsObject: Decodable {
                        var contents: [ContentObject]
                        struct ContentObject: Decodable {
                            var shelfRenderer: ShelfRendererObject?
                            struct ShelfRendererObject: Decodable {
                                var content: ShelfRendererContentObject
                                struct ShelfRendererContentObject: Decodable {
                                    var horizontalListRenderer: HorizontalListRendererObject
                                    struct HorizontalListRendererObject: Decodable {
                                        var items: [HorizontalListRendererItemObject]
                                        struct HorizontalListRendererItemObject: Decodable {
                                            var gridVideoRenderer: GridVideoRendererObject?
                                            struct GridVideoRendererObject: Decodable {
                                                var videoId: String
                                                var thumbnail: GridVideoRendererThumbnailObject
                                                var title: RunsTextObject
                                                var publishedTimeText: RunsTextObject
                                                var viewCountText: RunsTextObject
                                                var lengthText: RunsTextObject
                                                struct GridVideoRendererThumbnailObject: Decodable {
                                                    var thumbnails: [ImageObject]
                                                }
                                                struct RunsTextObject: Decodable {
                                                    var runs: [RunsObject]
                                                    struct RunsObject: Decodable {
                                                        var text: String
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
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

            var recommendedVideos: [VideoObject.RecommendedVideoObject] = []
            let (nextData, _) = try await request(
                for: "/youtubei/v1/next",
                with: [URLQueryItem(name: "videoId", value: idPath)]
            )
            let nextJson = try Self.decoder.decode(NextResponseObject.self, from: nextData)
            for content in nextJson.contents.singleColumnWatchNextResults.results.results.contents {
                if content.shelfRenderer != nil {
                    for item in content.shelfRenderer!.content.horizontalListRenderer.items {
                        if let gridVideoRenderer = item.gridVideoRenderer {
                            var lengthSeconds: Int = 0
                            if let lengthString = gridVideoRenderer.lengthText.runs.first?.text {
                                lengthSeconds = timeStringToSeconds(lengthString) ?? 0
                            }
                            recommendedVideos.append(
                                VideoObject.RecommendedVideoObject(
                                    videoId: gridVideoRenderer.videoId,
                                    title: gridVideoRenderer.title.runs.first?.text ?? "",
                                    lengthSeconds: lengthSeconds,
                                    videoThumbnails: gridVideoRenderer.thumbnail.thumbnails
                                )
                            )
                        } else {
                            print("Missing gridVideoRenderer for video \(id)")
                        }
                    }
                }
            }

            return VideoObject(
                title: json.videoDetails.title,
                videoId: json.videoDetails.videoId,
                lengthSeconds: Int(json.videoDetails.lengthSeconds) ?? 0,
                videoThumbnails: json.videoDetails.thumbnail.thumbnails,
                viewCount: Int64(json.videoDetails.viewCount),
                author: json.videoDetails.author,
                authorId: json.videoDetails.channelId,
                hlsUrl: json.streamingData.hlsManifestUrl,
                recommendedVideos: recommendedVideos
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

    func timeStringToSeconds(_ timeString: String) -> Int? {
        let components = timeString.split(separator: ":").map { Int($0) }
        guard components.allSatisfy({ $0 != nil }) else {
            return nil
        }
        let timeComponents = components.compactMap { $0 }
        switch timeComponents.count {
        case 2: // Format is "MM:SS"
            let minutes = timeComponents[0]
            let seconds = timeComponents[1]
            return (minutes * 60) + seconds
        case 3: // Format is "HH:MM:SS"
            let hours = timeComponents[0]
            let minutes = timeComponents[1]
            let seconds = timeComponents[2]
            return (hours * 3600) + (minutes * 60) + seconds
        default: // Invalid format
            return nil
        }
    }
}
