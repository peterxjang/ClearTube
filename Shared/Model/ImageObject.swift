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

    func fixedUrl() -> String {
        let pattern = "(hqdefault)(.*?)(\\.jpg)"
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        let range = NSRange(location: 0, length: url.utf16.count)
        return regex.stringByReplacingMatches(in: url, options: [], range: range, withTemplate: "$1$3")
    }
}

extension Array where Element == ImageObject {
    func preferredThumbnail(for width: CGFloat = 400) -> ImageObject? {
        let fixedImages = self.map { imageObject in
            var newImageObject = imageObject
            newImageObject.url = imageObject.fixedUrl()
            return newImageObject
        }
        return fixedImages
            .sorted { $0.width <= $1.width }
            .first { $0.width >= Int(width) }
            ?? fixedImages.max { $0.width < $1.width }
    }
}
