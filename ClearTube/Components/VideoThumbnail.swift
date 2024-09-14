import SwiftUI

struct VideoThumbnail: View {
    let width: CGFloat
    let height: CGFloat
    let radius: CGFloat
    var thumbnails: [ImageObject]

    var preferredThumbnail: ImageObject? {
        thumbnails
            .sorted { $0.width <= $1.width }
            .first { $0.width >= Int(width) }
    }

    var body: some View {
        Rectangle().foregroundStyle(.background)
            .frame(maxWidth: width, maxHeight: height)
            .aspectRatio(16 / 9, contentMode: .fill)
            .background(Rectangle().foregroundStyle(.background))
            .overlay {
                if let thumbnailUrl = preferredThumbnail?.url, let url = URL(string: thumbnailUrl) {
                    CacheAsyncImage(url: url) { image in
                        image.resizable().scaledToFill()
                            .frame(maxWidth: width, maxHeight: height)
                    } placeholder: {}
                        .frame(maxWidth: width, maxHeight: height)
                        .clipped()
                }
            }
            .cornerRadius(radius)
            .clipped()
    }
}
