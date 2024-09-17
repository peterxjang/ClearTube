import Foundation

public final class InnerTubeAPI {
    let baseUrl: URL? = URL(string: "https://youtubei.googleapis.com")
    var session: URLSession
    static var decoder = JSONDecoder()

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

    struct NextResponse: Decodable {
        var contents: ContentsResponse
        struct ContentsResponse: Decodable {
            var singleColumnWatchNextResults: SingleColumnWatchNextResultsResponse
            struct SingleColumnWatchNextResultsResponse: Decodable {
                var results: ResultsResponse
                struct ResultsResponse: Decodable {
                    var results: ResultsResponse
                    struct ResultsResponse: Decodable {
                        var contents: [ContentResponse]
                        struct ContentResponse: Decodable {
                            var shelfRenderer: ShelfRendererResponse?
                            struct ShelfRendererResponse: Decodable {
                                var content: ContentResponse
                                struct ContentResponse: Decodable {
                                    var horizontalListRenderer: HorizontalListRendererResponse
                                    struct HorizontalListRendererResponse: Decodable {
                                        var items: [ItemResponse]
                                        struct ItemResponse: Decodable {
                                            var gridVideoRenderer: GridVideoRendererResponse?
                                            struct GridVideoRendererResponse: Decodable {
                                                var videoId: String
                                                var thumbnail: ThumbnailResponse
                                                struct ThumbnailResponse: Decodable {
                                                    var thumbnails: [ImageObject]
                                                }
                                                var title: RunsTextResponse
                                                struct RunsTextResponse: Decodable {
                                                    var runs: [RunsResponse]
                                                    struct RunsResponse: Decodable {
                                                        var text: String
                                                    }
                                                }
                                                var publishedTimeText: RunsTextResponse
                                                var viewCountText: RunsTextResponse
                                                var lengthText: RunsTextResponse
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

    struct SearchResponse: Decodable {
        var estimatedResults: String
        var contents: ContentsResponse
        struct ContentsResponse: Decodable {
            var sectionListRenderer: SectionListRendererResponse
            struct SectionListRendererResponse: Decodable {
                var contents: [ContentResponse]
                struct ContentResponse: Decodable {
                    // CHANNEL
                    var shelfRenderer: ShelfRendererResponse?
                    struct ShelfRendererResponse: Decodable {
                        var content: ContentResponse
                        struct ContentResponse: Decodable {
                            var verticalListRenderer: VerticalListRendererResponse
                            struct VerticalListRendererResponse: Decodable {
                                var items: [ItemResponse]
                                struct ItemResponse: Decodable {
                                    var elementRenderer: ElementRendererResponse
                                    struct ElementRendererResponse: Decodable {
                                        var newElement: NewElementResponse
                                        struct NewElementResponse: Decodable {
                                            var type: TypeResponse
                                            struct TypeResponse: Decodable {
                                                var componentType: ComponentTypeResponse
                                                struct ComponentTypeResponse: Decodable {
                                                    var model: ModelResponse
                                                    struct ModelResponse: Decodable {
                                                        var compactChannelModel: CompactChannelModelResponse?
                                                        struct CompactChannelModelResponse: Decodable {
                                                            var compactChannelData: CompactChannelDataResponse
                                                            struct CompactChannelDataResponse: Decodable {
                                                                var avatar: AvatarResponse
                                                                struct AvatarResponse: Decodable {
                                                                    var image: ImageResponse
                                                                    struct ImageResponse: Decodable {
                                                                        var sources: [ImageObject]
                                                                    }
                                                                }
                                                                var title: String
                                                                var subscriberCount: String
                                                                var videoCount: String
                                                                var onTap: OnTapResponse
                                                                struct OnTapResponse: Decodable {
                                                                    var innertubeCommand: InnertubeCommandResponse
                                                                    struct InnertubeCommandResponse: Decodable {
                                                                        var browseEndpoint: BrowseEndpointResponse
                                                                        struct BrowseEndpointResponse: Decodable {
                                                                            var browseId: String
                                                                            var canonicalBaseUrl: String
                                                                        }
                                                                    }
                                                                }
                                                                var handle: String
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
                    // VIDEO
                    var itemSectionRenderer: ItemSectionRendererResponse?
                    struct ItemSectionRendererResponse: Decodable {
                        var contents: [ContentResponse]
                        struct ContentResponse: Decodable {
                            var elementRenderer: ElementRendererResponse?
                            struct ElementRendererResponse: Decodable {
                                var newElement: NewElementResponse
                                struct NewElementResponse: Decodable {
                                    var type: TypeResponse
                                    struct TypeResponse: Decodable {
                                        var componentType: ComponentTypeResponse?
                                        struct ComponentTypeResponse: Decodable {
                                            var model: ModelResponse
                                            struct ModelResponse: Decodable {
                                                var compactVideoModel: CompactVideoModelResponse?
                                                struct CompactVideoModelResponse: Decodable {
                                                    var compactVideoData: CompactVideoDataResponse
                                                    struct CompactVideoDataResponse: Decodable {
                                                        var videoData: VideoDataResponse
                                                        struct VideoDataResponse: Decodable {
                                                            var thumbnail: ThumbnailResponse
                                                            struct ThumbnailResponse: Decodable {
                                                                var image: ImageResponse
                                                                struct ImageResponse: Decodable {
                                                                    var sources: [ImageObject]
                                                                }
                                                                var timestampText: String?
                                                            }
                                                            var metadata: MetadataResponse
                                                            struct MetadataResponse: Decodable {
                                                                var title: String
                                                                var byline: String
                                                                var metadataDetails: String
                                                            }
                                                        }
                                                        var onTap: OnTapResponse
                                                        struct OnTapResponse: Decodable {
                                                            var innertubeCommand: InnertubeCommandResponse
                                                            struct InnertubeCommandResponse: Decodable {
                                                                var coWatchWatchEndpointWrapperCommand: CoWatchWatchEndpointWrapperCommandResponse
                                                                struct CoWatchWatchEndpointWrapperCommandResponse: Decodable {
                                                                    var watchEndpoint: WatchEndpoint
                                                                    struct WatchEndpoint: Decodable {
                                                                        var watchEndpoint: WatchEndpoint
                                                                        struct WatchEndpoint: Decodable {
                                                                            var videoId: String
                                                                        }
                                                                    }
                                                                    var videoTitle: String
                                                                    var ownerDisplayName: String
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
            }
        }
    }

    struct RequestBody: Codable {
        let context: Context
        struct Context: Codable {
            let client: Client
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
            let user: User
            struct User: Codable {
                let lockedSafetyMode: Bool
            }
            let request: RequestContext
            struct RequestContext: Codable {
                let useSsl: Bool
                let internalExperimentFlags: [String]
                let consistencyTokenJars: [String]
            }
        }
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
                context: RequestBody.Context(
                    client: RequestBody.Context.Client(
                        clientName: "IOS",
                        clientVersion: "19.16.3",
                        hl: "en",
                        gl: "US",
                        deviceMake: "Apple",
                        deviceModel: "iPhone",
                        experimentIds: [],
                        utcOffsetMinutes: 0
                    ),
                    user: RequestBody.Context.User(
                        lockedSafetyMode: false
                    ),
                    request: RequestBody.Context.RequestContext(
                        useSsl: true,
                        internalExperimentFlags: [],
                        consistencyTokenJars: []
                    )
                )
            )
        )
        return try await session.data(for: request)
    }

    func playerEndpoint(for id: String) async throws -> PlayerResponse {
        guard let idPath = id.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            throw APIError.urlCreation
        }
        do {
            let (data, _) = try await request(
                for: "/youtubei/v1/player",
                with: [URLQueryItem(name: "videoId", value: idPath)]
            )
            return try Self.decoder.decode(PlayerResponse.self, from: data)
        } catch {
            print("An error occurred: \(error.localizedDescription)")
            print("Error details: \(error)")
            throw error
        }
    }

    func searchEndpoint(query: String) async throws -> SearchResponse {
        let (data, _) = try await request(
            for: "/youtubei/v1/search",
            with: [URLQueryItem(name: "query", value: query)]
        )
        return try Self.decoder.decode(SearchResponse.self.self, from: data)
    }

    func nextEndpoint(for id: String) async throws -> NextResponse {
        guard let idPath = id.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            throw APIError.urlCreation
        }
        do {
            let (data, _) = try await request(
                for: "/youtubei/v1/next",
                with: [URLQueryItem(name: "videoId", value: idPath)]
            )
            return try Self.decoder.decode(NextResponse.self, from: data)
        } catch {
            print("An error occurred: \(error.localizedDescription)")
            print("Error details: \(error)")
            throw error
        }
    }

    func extractRecommendedVideos(json: NextResponse) -> [VideoObject.RecommendedVideoObject] {
        var recommendedVideos: [VideoObject.RecommendedVideoObject] = []
        for content in json.contents.singleColumnWatchNextResults.results.results.contents {
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
                        print("Missing gridVideoRenderer")
                    }
                }
            }
        }
        return recommendedVideos
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

    func video(for id: String) async throws -> VideoObject {
        async let playerTask = playerEndpoint(for: id)
        async let nextTask = nextEndpoint(for: id)
        do {
            let (json, nextJson) = try await(playerTask, nextTask)
            let recommendedVideos = extractRecommendedVideos(json: nextJson)
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
        let json = try await ClearTubeApp.innerTubeClient.searchEndpoint(query: query)
        var results: [SearchObject.Result] = []
        for contentJson in json.contents.sectionListRenderer.contents {
            // CHANNEL
            if let shelfRenderer = contentJson.shelfRenderer {
                for item in shelfRenderer.content.verticalListRenderer.items {
                    if let compactChannelModel = item.elementRenderer.newElement.type.componentType.model.compactChannelModel {
                        let author = compactChannelModel.compactChannelData.title
                        let authorId = compactChannelModel.compactChannelData.onTap.innertubeCommand.browseEndpoint.browseId
                        let authorUrl = compactChannelModel.compactChannelData.onTap.innertubeCommand.browseEndpoint.canonicalBaseUrl
                        let authorThumbnails = compactChannelModel.compactChannelData.avatar.image.sources
                        let subCountText = compactChannelModel.compactChannelData.subscriberCount
                        results.append(
                            SearchObject.Result(from: ChannelObject(
                                author: author,
                                authorId: authorId,
                                authorUrl: authorUrl,
                                authorThumbnails: authorThumbnails,
                                subCountText: subCountText
                            ))
                        )
                    }
                }
            }
            // VIDEO
            if let itemSectionRenderer = contentJson.itemSectionRenderer {
                for content in itemSectionRenderer.contents {
                    if let model = content.elementRenderer?.newElement.type.componentType?.model, let compactVideoModel = model.compactVideoModel {
                        let title = compactVideoModel.compactVideoData.videoData.metadata.title
                        let videoId = compactVideoModel.compactVideoData.onTap.innertubeCommand.coWatchWatchEndpointWrapperCommand.watchEndpoint.watchEndpoint.videoId
                        let timestampText = compactVideoModel.compactVideoData.videoData.thumbnail.timestampText ?? "0:0"
                        let videoThumbnails = compactVideoModel.compactVideoData.videoData.thumbnail.image.sources
                        let author = compactVideoModel.compactVideoData.videoData.metadata.byline
                        results.append(
                            SearchObject.Result(from: VideoObject(
                                title: title,
                                videoId: videoId,
                                lengthSeconds: timeStringToSeconds(timestampText) ?? 0,
                                videoThumbnails: videoThumbnails,
                                author: author
                            ))
                        )
                    }
                }
            }
        }
        return results
    }
}
