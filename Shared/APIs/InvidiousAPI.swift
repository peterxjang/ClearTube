import Foundation

public enum APIError: LocalizedError {
    case urlCreation
    case missingJSON
}

private struct Stats: Decodable {
    var software: Stats.Software

    struct Software: Decodable {
        var name: String
    }
}

public final class InvidiousAPI {
    public var baseUrl: URL?
    var session: URLSession
    static var decoder = JSONDecoder()

    public init(apiUrl: URL? = nil, timeoutIntervalForRequest: TimeInterval = 5, timeoutIntervalForResource: TimeInterval = 60) {
        self.baseUrl = apiUrl
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = timeoutIntervalForRequest
        configuration.timeoutIntervalForResource = timeoutIntervalForResource
        self.session = URLSession(configuration: configuration)
    }

    public func setApiUrl(url: URL?) {
        baseUrl = url
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
        return try await session.data(from: url)
    }

    public static func isValidInstance(url: URL) async -> Bool {
        guard
            let statsUrl = URL(string: "/api/v1/stats", relativeTo: url),
            let (data, _) = try? await URLSession.shared.data(from: statsUrl),
            let stats = try? decoder.decode(Stats.self, from: data)
        else {
            return false
        }
        return stats.software.name == "invidious"
    }

    func video(for id: String) async throws -> VideoObject {
        guard let idPath = id.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            throw APIError.urlCreation
        }
        do {
            let (data, _) = try await request(for: "/api/v1/videos/\(idPath)")
            return try Self.decoder.decode(VideoObject.self, from: data)
        } catch {
            print("An error occurred: \(error.localizedDescription)")
            print("Error details: \(error)")
            throw error
        }
    }

    func search(query: String, page: Int32) async throws -> [SearchObject.Result] {
        let (data, _) = try await request(for: "/api/v1/search", with: [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "page", value: page.description)
        ])
        return try Self.decoder.decode([SearchObject.Result].self, from: data)
    }

    func channel(for id: String) async throws -> ChannelObject {
        guard let idPath = id.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            throw APIError.urlCreation
        }
        let (data, _) = try await request(for: "/api/v1/channels/\(idPath)")
        return try Self.decoder.decode(ChannelObject.self, from: data)
    }

    func videos(for channelId: String, continuation: String?) async throws -> ChannelObject.VideosResponse {
        guard let idPath = channelId.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            throw APIError.urlCreation
        }
        let (data, _) = try await request(for: "/api/v1/channels/\(idPath)/videos")
        return try Self.decoder.decode(ChannelObject.VideosResponse.self, from: data)
    }

    func shorts(for channelId: String, continuation: String?) async throws -> ChannelObject.VideosResponse {
        guard let idPath = channelId.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            throw APIError.urlCreation
        }
        let (data, _) = try await request(for: "/api/v1/channels/\(idPath)/shorts")
        return try Self.decoder.decode(ChannelObject.VideosResponse.self, from: data)
    }

    func streams(for channelId: String, continuation: String?) async throws -> ChannelObject.VideosResponse {
        guard let idPath = channelId.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            throw APIError.urlCreation
        }
        let (data, _) = try await request(for: "/api/v1/channels/\(idPath)/streams")
        do {
            return try Self.decoder.decode(ChannelObject.VideosResponse.self, from: data)
        } catch {
            throw error
        }
    }

    func playlists(for channelId: String, continuation: String?) async throws -> ChannelObject.PlaylistResponse {
        guard let idPath = channelId.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            throw APIError.urlCreation
        }
        let (data, _) = try await request(for: "/api/v1/channels/\(idPath)/playlists")
        return try Self.decoder.decode(ChannelObject.PlaylistResponse.self, from: data)
    }

    func playlist(for id: String) async throws -> PlaylistObject {
        guard let idPath = id.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            throw APIError.urlCreation
        }
        let (data, _) = try await request(for: "/api/v1/playlists/\(idPath)")
        return try Self.decoder.decode(PlaylistObject.self, from: data)
    }
}
