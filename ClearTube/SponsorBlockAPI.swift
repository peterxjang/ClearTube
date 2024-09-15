import Foundation

public struct SponsorBlockObject: Decodable {
    public var category: String
    public var actionType: String
    public var segment: [Float]
    public var UUID: String
    public var videoDuration: Float
    public var locked: Int
    public var votes: Int
    public var description: String
}

public final class SponsorBlockAPI {
    static func sponsorSegments(id: String) async throws -> [[Float]] {
        let url = URL(string: "https://sponsor.ajay.app/api/skipSegments?videoID=\(id)")!
        let request = URLRequest(url: url)
        let (data, _) = try await URLSession.shared.data(for: request)
        if let videoInfo = try? JSONDecoder().decode([SponsorBlockObject].self, from: data) {
            return videoInfo.map { $0.segment }
        } else {
            print("SponsorBlock Invalid Response")
            return []
        }
    }
}
