import SwiftUI
import SwiftData

struct VideoThumbnail: View {
    let width: CGFloat
    let height: CGFloat
    let radius: CGFloat
    var thumbnail: ImageObject?

    var body: some View {
        Rectangle().foregroundStyle(.background)
            .frame(maxWidth: width, maxHeight: height)
            .aspectRatio(16 / 9, contentMode: .fill)
            .background(Rectangle().foregroundStyle(.background))
            .overlay {
                CacheAsyncImage(url: thumbnail?.getURL()) { image in
                    image.resizable().scaledToFill()
                        .frame(maxWidth: width, maxHeight: height)
                } placeholder: {}
                    .frame(maxWidth: width, maxHeight: height)
                    .clipped()
            }
            .cornerRadius(radius)
            .clipped()
    }
}

struct VideoThumbnailTag: View {
    var content: String?

    init(_ content: String) {
        self.content = content
    }

    init(_ seconds: Int) {
        let formattedTime = (Date() ..< Date().advanced(by: TimeInterval(seconds))).formatted(.timeDuration)
        if seconds <= 0 {
            return
        } else if seconds < 10 {
           self.content = "0:0\(formattedTime)"
        } else if seconds < 60 {
            self.content = "0:\(formattedTime)"
        } else {
            self.content = formattedTime
        }
    }

    var body: some View {
        VStack {
            if let content = content {
                Spacer()
                HStack {
                    Spacer()
                    Group {
                        Text(content)
                            .padding(.horizontal, 6.0)
                            .padding(.vertical, 2.0)
                            .font(.caption2)
                    }
                    .background(.black)
                    .foregroundStyle(.white)
                    .cornerRadius(4.0)
                    .padding([.bottom, .trailing], 4.0)
                }
            }
        }
    }
}

struct VideoThumbnailWatchProgress: View {
    var video: VideoObject
    var width: CGFloat
    @Query var historyVideos: [HistoryVideo]

    var body: some View {
        if let historyVideo = historyVideos.first(where: { $0.videoId == video.videoId }) {
            let progress = video.lengthSeconds > 0 ? CGFloat(historyVideo.watchedSeconds) / CGFloat(video.lengthSeconds) : 1.0
            Rectangle()
                .fill(Color(UIColor.lightGray))
                .frame(width: width, height: 5)
            Rectangle()
                .fill(Color.red)
                .frame(width: width * progress, height: 5)
        }
    }
}
