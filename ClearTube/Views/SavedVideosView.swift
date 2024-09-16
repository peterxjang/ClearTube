import SwiftUI
import SwiftData

struct SavedVideosView: View {
    @Environment(\.modelContext) private var context
    @Query var watchLaterVideos: [WatchLaterVideo]
    @Query var recommendedVideos: [RecommendedVideo]
    @Query var historyVideos: [HistoryVideo]
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
                                            url: watchLaterVideo.thumbnailUrl ?? "",
                                            width: watchLaterVideo.thumbnailWidth ?? 0,
                                            height: watchLaterVideo.thumbnailHeight ?? 0
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

                Text("Recommended")
                    .font(.subheadline)
                    .padding(.top, 50)
                ScrollView(.horizontal) {
                    LazyHGrid(rows: [.init(.flexible())], alignment: .top, spacing: 70.0) {
                        ForEach(recommendedVideos.shuffled()) { recommendedVideo in
                            VideoCard(video:
                                VideoObject(
                                    title: recommendedVideo.title,
                                    videoId: recommendedVideo.videoId,
                                    lengthSeconds: recommendedVideo.lengthSeconds,
                                    videoThumbnails: [
                                        ImageObject(
                                            url: recommendedVideo.thumbnailUrl ?? "",
                                            width: recommendedVideo.thumbnailWidth ?? 0,
                                            height: recommendedVideo.thumbnailHeight ?? 0
                                        )
                                    ],
                                    published: recommendedVideo.published,
                                    viewCountText: recommendedVideo.viewCountText,
                                    author: recommendedVideo.author,
                                    authorId: recommendedVideo.authorId
                                )
                            )
                        }
                    }.padding(20)
                }

                Text("Recent History")
                    .font(.subheadline)
                    .padding(.top, 50)
                ScrollView(.horizontal) {
                    LazyHGrid(rows: [.init(.flexible())], alignment: .top, spacing: 70.0) {
                        ForEach(historyVideos.reversed()) { historyVideo in
                            VideoCard(video:
                                VideoObject(
                                    title: historyVideo.title,
                                    videoId: historyVideo.videoId,
                                    lengthSeconds: historyVideo.lengthSeconds,
                                    videoThumbnails: [
                                        ImageObject(
                                            url: historyVideo.thumbnailUrl ?? "",
                                            width: historyVideo.thumbnailWidth ?? 0,
                                            height: historyVideo.thumbnailHeight ?? 0
                                        )
                                    ],
                                    published: historyVideo.published,
                                    viewCountText: historyVideo.viewCountText,
                                    author: historyVideo.author,
                                    authorId: historyVideo.authorId
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
