import SwiftUI
import SwiftData

struct SavedVideosView: View {
    @Environment(\.modelContext) private var context
    @Query var watchLaterVideos: [WatchLaterVideo]
    @Query var recommendedVideos: [RecommendedVideo]
    @Query var historyVideos: [HistoryVideo]
    @Binding var reloadTrigger: Bool
    var settings = Settings()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Watch Later")
                    .font(.subheadline)
                ScrollView(.horizontal) {
                    LazyHGrid(rows: [.init(.flexible())], alignment: .top, spacing: 70.0) {
                        ForEach(watchLaterVideos.reversed()) { watchLaterVideo in
                            VideoCard(video: VideoObject(for: watchLaterVideo))
                        }
                    }.padding(40)
                }

                Text("Recommended")
                    .font(.subheadline)
                    .padding(.top, 50)
                ScrollView(.horizontal) {
                    LazyHGrid(rows: [.init(.flexible())], alignment: .top, spacing: 70.0) {
                        ForEach(recommendedVideos.shuffled()) { recommendedVideo in
                            VideoCard(video: VideoObject(for: recommendedVideo))
                        }
                    }.padding(40)
                }

                Text("Recent History")
                    .font(.subheadline)
                    .padding(.top, 50)
                ScrollView(.horizontal) {
                    LazyHGrid(rows: [.init(.flexible())], alignment: .top, spacing: 70.0) {
                        ForEach(historyVideos.reversed()) { historyVideo in
                            VideoCard(video: VideoObject(for: historyVideo))
                        }
                    }.padding(40)
                }
            }
        }
        .id(reloadTrigger)
    }
}
