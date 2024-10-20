import SwiftUI
import SwiftData
import Observation

@Observable
class PlaylistViewModel {
    var playlistId: String
    var title: String?
    var videos: [VideoObject] = []
    var loading = true
    var error: Error?

    init(playlistId: String) {
        self.playlistId = playlistId
    }

    func load() async {
        loading = true
        do {
            let response = try await ClearTubeApp.innerTubeClient.playlist(for: playlistId)
            title = response.title
            videos = response.videos
        } catch {
            print(error)
            self.error = error
        }
        loading = false
    }
}

struct PlaylistView: View {
    var model: PlaylistViewModel
    var saveRecommendations: Bool = false

    var body: some View {
        GeometryReader { geometry in
            let minWidth: CGFloat = 250
            let screenWidth = geometry.size.width
            let columns = Int(screenWidth / minWidth)
            let spacing: CGFloat = screenWidth / 20.0
            let width = (screenWidth - CGFloat(columns - 1) * spacing) / CGFloat(columns)

            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: spacing), count: columns), spacing: spacing) {
                    ForEach(model.videos, id: \.videoId) { video in
                        VideoCard(video: video, width: width, saveRecommendations: saveRecommendations)
                    }
                }.padding(spacing)
            }
            .navigationTitle(model.title ?? "Playlist")
            .asyncTaskOverlay(error: model.error, isLoading: model.loading)
            .task {
                await model.load()
            }.refreshable {
                await model.load()
            }
        }
    }
}
