import SwiftUI
import SwiftData

struct SavedVideosView: View {
    @Environment(\.modelContext) private var context
    @Query var watchLaterVideos: [WatchLaterVideo]
    var settings = Settings()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Watch Later")
                    .font(.subheadline)
                ScrollView(.horizontal) {
                    LazyHGrid(rows: [.init(.flexible())], alignment: .top, spacing: 70.0) {
                        ForEach(watchLaterVideos.reversed()) { watchLaterVideo in
                            VideoCard(video:
                                VideoObject(
                                    title: watchLaterVideo.title,
                                    videoId: watchLaterVideo.videoId,
                                    lengthSeconds: watchLaterVideo.lengthSeconds,
                                    videoThumbnails: [
                                        ImageObject(
                                            quality: watchLaterVideo.thumbnailQuality,
                                            url: watchLaterVideo.thumbnailUrl,
                                            width: watchLaterVideo.thumbnailWidth,
                                            height: watchLaterVideo.thumbnailHeight
                                        )
                                    ],
                                    published: watchLaterVideo.published,
                                    viewCountText: watchLaterVideo.viewCountText,
                                    author: watchLaterVideo.author,
                                    authorId: watchLaterVideo.authorId
                                )
                            )
                        }
                    }.padding(20)
                }
            }
            .navigationTitle("Watch Later")
            .padding(50)
        }
    }
}
