import Foundation

public final class InnerTubeAPI {
    let baseUrl: URL? = URL(string: "https://youtubei.googleapis.com")
    var session: URLSession
    static var decoder = JSONDecoder()

    public struct PlayerResponseObject: Decodable {
        public var streamingData: StreamingDataObject
        public var videoDetails: VideoDetailsObject

        public struct StreamingDataObject: Decodable {
            public var hlsManifestUrl: String
            public var adaptiveFormats: [StreamingDataAdaptiveFormatObject]

            public struct StreamingDataAdaptiveFormatObject: Decodable {
                public var url: String
                public var mimeType: String
                public var bitrate: Int
                public var width: Int?
                public var height: Int?
            }
        }

        public struct VideoDetailsObject: Decodable {
            public var videoId: String
            public var title: String
            public var lengthSeconds: String
            public var viewCount: String
            public var author: String
            public var thumbnail: ThumbnailsObject

            public struct ThumbnailsObject: Decodable {
                public var thumbnails: [ImageObject]
            }
        }
    }

    public struct NextResponseObject: Decodable {
        public var contents: ContentsObject

        public struct ContentsObject: Decodable {
            public var singleColumnWatchNextResults: SingleColumnWatchNextResultsObject

            public struct SingleColumnWatchNextResultsObject: Decodable {
                public var results: ResultsObject

                public struct ResultsObject: Decodable {
                    public var results: SubResultsObject

                    public struct SubResultsObject: Decodable {
                        public var contents: [ContentObject]

                        public struct ContentObject: Decodable {
                            public var shelfRenderer: ShelfRendererObject?

                            public struct ShelfRendererObject: Decodable {
                                public var content: ShelfRendererContentObject

                                public struct ShelfRendererContentObject: Decodable {
                                    public var horizontalListRenderer: HorizontalListRendererObject

                                    public struct HorizontalListRendererObject: Decodable {
                                        public var items: [HorizontalListRendererItemObject]

                                        public struct HorizontalListRendererItemObject: Decodable {
                                            public var gridVideoRenderer: GridVideoRendererObject

                                            public struct GridVideoRendererObject: Decodable {
                                                public var videoId: String
                                                public var thumbnail: GridVideoRendererThumbnailObject
                                                public var title: RunsTextObject
                                                public var publishedTimeText: RunsTextObject
                                                public var viewCountText: RunsTextObject
                                                public var lengthText: RunsTextObject

                                                public struct GridVideoRendererThumbnailObject: Decodable {
                                                    public var thumbnails: [ImageObject]
                                                }

                                                public struct RunsTextObject: Decodable {
                                                    public var runs: [RunsObject]

                                                    public struct RunsObject: Decodable {
                                                        public var text: String
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

            let (nextData, _) = try await request(
                for: "/youtubei/v1/next",
                with: [URLQueryItem(name: "videoId", value: idPath)]
            )
            let nextJson = try Self.decoder.decode(NextResponseObject.self, from: nextData)
            var recommendedVideos: [VideoObject.RecommendedVideoObject] = []
            for content in nextJson.contents.singleColumnWatchNextResults.results.results.contents {
                if content.shelfRenderer != nil {
                    for item in content.shelfRenderer!.content.horizontalListRenderer.items {
                        print("RECOMMENDED VIDEO")
                        print(item.gridVideoRenderer)
                        print(" ")
                        var lengthSeconds: Int32 = 0
                        if let lengthString = item.gridVideoRenderer.lengthText.runs.first?.text {
                            lengthSeconds = timeStringToSeconds(lengthString) ?? 0
                        }
                        recommendedVideos.append(
                            VideoObject.RecommendedVideoObject(
                                videoId: item.gridVideoRenderer.videoId,
                                title: item.gridVideoRenderer.title.runs.first?.text ?? "",
                                videoThumbnails: item.gridVideoRenderer.thumbnail.thumbnails,
                                author: "",
                                authorId: "",
                                lengthSeconds: lengthSeconds
                            )
                        )
                    }
                }
            }

            return VideoObject(
                title: json.videoDetails.title,
                videoId: json.videoDetails.videoId,
                lengthSeconds: Int(json.videoDetails.lengthSeconds) ?? 0,
                videoThumbnails: json.videoDetails.thumbnail.thumbnails,
                author: json.videoDetails.author,
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

    func timeStringToSeconds(_ timeString: String) -> Int32? {
        let components = timeString.split(separator: ":").map { Int($0) }
        guard components.allSatisfy({ $0 != nil }) else {
            return nil
        }
        let timeComponents = components.compactMap { $0 }
        switch timeComponents.count {
        case 2: // Format is "MM:SS"
            let minutes = timeComponents[0]
            let seconds = timeComponents[1]
            return Int32((minutes * 60) + seconds)
        case 3: // Format is "HH:MM:SS"
            let hours = timeComponents[0]
            let minutes = timeComponents[1]
            let seconds = timeComponents[2]
            return Int32((hours * 3600) + (minutes * 60) + seconds)
        default: // Invalid format
            return nil
        }
    }
}