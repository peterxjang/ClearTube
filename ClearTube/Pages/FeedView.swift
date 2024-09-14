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
        let decoder = JSONDecoder()
        do {
            let url = URL(string: "/api/v1/channels/UCBJycsmduvYEL83R_U4JriQ", relativeTo: URL(string: "https://iv.ggtyler.dev"))!
            let request = URLRequest(url: url)
            let (data, _) = try await URLSession.shared.data(for: request)
            let channel = try decoder.decode(ChannelObject.self, from: data)
            videos = channel.latestVideos
            isLoading = false
        } catch {
            print("Error fetching videos: \(error)")
            isLoading = false
        }
    }
}
