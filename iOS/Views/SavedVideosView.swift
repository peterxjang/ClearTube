import SwiftUI
import SwiftData

struct SavedVideosView: View {
    @Environment(\.modelContext) private var context
    @Query var watchLaterVideos: [WatchLaterVideo]
    @Query var recommendedVideos: [RecommendedVideo]
    @Query var historyVideos: [HistoryVideo]
    var settings = Settings()

    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let spacing: CGFloat = screenWidth / 50.0
            let width = screenWidth / 3.0

            ScrollView {
                VStack(alignment: .leading) {
                    Text("Watch Later")
                        .font(.subheadline)
                    ScrollView(.horizontal) {
                        LazyHGrid(rows: [.init(.flexible())], alignment: .top, spacing: spacing) {
                            ForEach(watchLaterVideos.reversed()) { watchLaterVideo in
                                VideoCard(
                                    video: VideoObject(for: watchLaterVideo),
                                    width: width,
                                    saveRecommendations: true
                                )
                            }
                        }.padding(spacing)
                    }

                    Text("Recommended")
                        .font(.subheadline)
                        .padding(.top, spacing)
                    ScrollView(.horizontal) {
                        LazyHGrid(rows: [.init(.flexible())], alignment: .top, spacing: spacing) {
                            ForEach(recommendedVideos.shuffled()) { recommendedVideo in
                                VideoCard(
                                    video: VideoObject(for: recommendedVideo),
                                    width: width,
                                    saveRecommendations: true
                                )
                            }
                        }.padding(spacing)
                    }

                    Text("Recent History")
                        .font(.subheadline)
                        .padding(.top, spacing)
                    ScrollView(.horizontal) {
                        LazyHGrid(rows: [.init(.flexible())], alignment: .top, spacing: spacing) {
                            ForEach(historyVideos.reversed()) { historyVideo in
                                VideoCard(
                                    video: VideoObject(for: historyVideo),
                                    width: width
                                )
                            }
                        }.padding(spacing)
                    }
                }
            }
        }
    }
}
