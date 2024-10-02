import SwiftUI
import SwiftData

struct SavedVideosView: View {
    @Environment(\.modelContext) private var context
    @Query var watchLaterVideos: [WatchLaterVideo]
    @Query var recommendedVideos: [RecommendedVideo]
    @Query var historyVideos: [HistoryVideo]
    @State private var displayedRecommendedVideos: [RecommendedVideo] = []
    @FocusState private var isFirstVideoFocused: Bool
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
                    ScrollViewReader { scrollViewProxy in
                        LazyHGrid(rows: [.init(.flexible())], alignment: .top, spacing: 70.0) {
                            ForEach(displayedRecommendedVideos) { recommendedVideo in
                                VideoCard(video: VideoObject(for: recommendedVideo))
                                    .focused($isFirstVideoFocused, equals: recommendedVideo.id == displayedRecommendedVideos.first?.id)
                                    .id(recommendedVideo.id)
                            }
                            Button(action: {
                                loadRandomVideos()
                            }) {
                                Text("More")
                                    .foregroundColor(.blue)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 20)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(10)
                            }
                        }
                        .padding(40)
                        .onChange(of: displayedRecommendedVideos) {
                            if let firstVideoId = displayedRecommendedVideos.first?.id {
                                scrollViewProxy.scrollTo(firstVideoId, anchor: .leading)
                            }
                        }
                    }
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
        .onAppear {
            loadRandomVideos()
        }
    }

    private func loadRandomVideos() {
        let randomBatch = recommendedVideos.shuffled().prefix(10)
        displayedRecommendedVideos = Array(randomBatch)
        isFirstVideoFocused = true
    }
}
