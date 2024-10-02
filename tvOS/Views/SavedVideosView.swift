import SwiftUI
import SwiftData

struct SavedVideosView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                WatchLaterView()
                RecommendedView()
                HistoryView()
            }
        }
    }
}

struct WatchLaterView: View {
    @Query var watchLaterVideos: [WatchLaterVideo]
    
    var body: some View {
        Text("Watch Later")
            .font(.subheadline)
        ScrollView(.horizontal) {
            LazyHGrid(rows: [.init(.flexible())], alignment: .top, spacing: 70.0) {
                ForEach(watchLaterVideos.reversed()) { watchLaterVideo in
                    VideoCard(video: VideoObject(for: watchLaterVideo))
                }
            }.padding(40)
        }
    }
}

struct RecommendedView: View {
    @Query var recommendedVideos: [RecommendedVideo]
    @State private var displayedRecommendedVideos: [RecommendedVideo] = []
    @State var reloaded: Bool = false
    
    var body: some View {
        Text("Recommended")
            .font(.subheadline)
            .padding(.top, 50)
        ScrollView(.horizontal) {
            ScrollViewReader { scrollViewProxy in
                LazyHGrid(rows: [.init(.flexible())], alignment: .top, spacing: 70.0) {
                    ForEach(displayedRecommendedVideos) { recommendedVideo in
                        VideoCard(video: VideoObject(for: recommendedVideo))
                    }
                    Button(action: {
                        loadRandomVideos()
                        reloaded = true
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
                    if let firstVideoId = displayedRecommendedVideos.first?.id, reloaded {
                        scrollViewProxy.scrollTo(firstVideoId, anchor: .leading)
                    }
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
    }
}

struct HistoryView: View {
    @Query var historyVideos: [HistoryVideo]
    
    var body: some View {
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
