import Foundation

public struct ImageObject: Hashable, Decodable {
    public var quality: String?
    public var url: String
    public var width: Int
    public var height: Int
    
    public static func == (lhs: ImageObject, rhs: ImageObject) -> Bool {
        lhs.url == rhs.url
    }

    func getURL() -> URL {
        var components = URLComponents(string: url)!
        components.query = nil
        return components.url!
    }
}

extension Array where Element == ImageObject {
    func preferredThumbnail(for width: CGFloat = 400) -> ImageObject? {
        self
            .sorted { $0.width <= $1.width }
            .first { $0.width >= Int(width) }
            ?? self.max { $0.width < $1.width }
    }
}
