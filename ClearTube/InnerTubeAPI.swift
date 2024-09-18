import Foundation

public final class InnerTubeAPI {
    let baseUrl: URL? = URL(string: "https://youtubei.googleapis.com")
    var session: URLSession
    static var decoder = JSONDecoder()

    public init(session: URLSession = .shared) {
        self.session = session
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

    func browseEndpoint(browseId: String, params: String? = nil) async throws -> BrowseResponse {
        var queryParams: [URLQueryItem]
        if let params = params {
            queryParams = [URLQueryItem(name: "browseId", value: browseId), URLQueryItem(name: "params", value: params)]
        } else {
            queryParams = [URLQueryItem(name: "browseId", value: browseId)]
        }
        let (data, _) = try await request(
            clientName: "WEB",
            clientVersion: "2.20230728.00.00",
            for: "/youtubei/v1/browse",
            with: queryParams
        )
        return try Self.decoder.decode(BrowseResponse.self.self, from: data)
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
        return extractSearchResults(json: json)
    }

    func videos(for channelId: String, continuation: String?, channelName: String? = nil) async throws -> ChannelObject.VideosResponse {
        guard let browseId = channelId.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            throw APIError.urlCreation
        }
        let json = try await browseEndpoint(browseId: browseId)
        guard let videosTabRenderer = json.contents.twoColumnBrowseResultsRenderer.tabs[1].tabRenderer else {
            throw APIError.urlCreation
        }
        let author = videosTabRenderer.endpoint.browseEndpoint.canonicalBaseUrl
        let videoParams = videosTabRenderer.endpoint.browseEndpoint.params
        let json2 = try await browseEndpoint(browseId: browseId, params: videoParams)
        var videos: [VideoObject] = []
        for tab in json2.contents.twoColumnBrowseResultsRenderer.tabs {
            if let tabRenderer = tab.tabRenderer {
                if let content = tabRenderer.content, let richGridRenderer = content.richGridRenderer {
                    for content in richGridRenderer.contents {
                        if let richItemRenderer = content.richItemRenderer {
                            let videoRenderer = richItemRenderer.content.videoRenderer
                            let videoId = videoRenderer.videoId
                            let title = videoRenderer.title.runs[0].text
                            let lengthSeconds = timeStringToSeconds(videoRenderer.lengthText.simpleText) ?? 0
                            let videoThumbnails = videoRenderer.thumbnail.thumbnails
                            let publishedText = videoRenderer.publishedTimeText.simpleText
                            let viewCountText = videoRenderer.viewCountText.simpleText
                            videos.append(
                                VideoObject(
                                    title: title,
                                    videoId: videoId,
                                    lengthSeconds: lengthSeconds,
                                    videoThumbnails: videoThumbnails,
                                    published: timeAgoStringToUnix(publishedText),
                                    publishedText: publishedText,
                                    viewCountText: viewCountText,
                                    author: channelName ?? author,
                                    authorId: browseId
                                )
                            )
                        }
                    }
                }
            }
        }
        return ChannelObject.VideosResponse(from: videos)
    }

    private func requestUrl(for string: String, with queryItems: [URLQueryItem]? = nil) -> URL? {
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

    private func request(
        clientName: String = "IOS",
        clientVersion: String = "19.16.3",
        for string: String,
        with queryItems: [URLQueryItem]? = nil
    ) async throws -> (Data, URLResponse) {
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
                        clientName: clientName,
                        clientVersion: clientVersion,
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

    private func extractRecommendedVideos(json: NextResponse) -> [VideoObject.RecommendedVideoObject] {
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

    private func extractSearchResults(json: SearchResponse) -> [SearchObject.Result] {
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

    private func timeStringToSeconds(_ timeString: String) -> Int? {
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

    private func timeAgoStringToUnix(_ timeAgo: String) -> Int64? {
        let now = Date()
        let calendar = Calendar.current
        let regex = try! NSRegularExpression(pattern: #"(\d+)\s(\w+)\sago"#, options: [])
        let nsRange = NSRange(timeAgo.startIndex..<timeAgo.endIndex, in: timeAgo)
        if let match = regex.firstMatch(in: timeAgo, options: [], range: nsRange) {
            let numberRange = Range(match.range(at: 1), in: timeAgo)
            let unitRange = Range(match.range(at: 2), in: timeAgo)
            guard let numberRange = numberRange, let unitRange = unitRange,
                  let number = Int(timeAgo[numberRange]) else {
                return nil
            }
            let unit = String(timeAgo[unitRange]).lowercased()
            var dateComponent = DateComponents()
            switch unit {
            case "second", "seconds":
                dateComponent.second = -number
            case "minute", "minutes":
                dateComponent.minute = -number
            case "hour", "hours":
                dateComponent.hour = -number
            case "day", "days":
                dateComponent.day = -number
            case "week", "weeks":
                dateComponent.day = -number * 7
            case "month", "months":
                dateComponent.month = -number
            case "year", "years":
                dateComponent.year = -number
            default:
                return nil
            }
            if let pastDate = calendar.date(byAdding: dateComponent, to: now) {
                let unixTime = Int(pastDate.timeIntervalSince1970)
                return Int64(unixTime)
            }
        }
        return nil
    }
}
