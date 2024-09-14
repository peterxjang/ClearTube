import SwiftUI

struct FeedView: View {
    @State private var isLoading: Bool = true
    @State private var videos: [VideoObject] = []
    
    var body: some View {
        ScrollView {
            VStack(alignment: .trailing) {
                if isLoading {
                    ProgressView()
                } else {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 100) {
                        ForEach(videos, id: \.videoId) { video in
                            VideoCard(video: video)
                        }
                    }
                }
            }
            .onAppear {
                Task {
                    await fetchVideos()
                }
            }
        }
    }
    
    private func fetchVideos() async {
        do {
            let channel = try await ClearTubeApp.client.videos(for: "UCBJycsmduvYEL83R_U4JriQ", continuation: nil)
            videos = channel.videos
            isLoading = false
        } catch {
            print("Error fetching videos: \(error)")
            isLoading = false
        }
    }
}
