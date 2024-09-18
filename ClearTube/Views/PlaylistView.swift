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
            let response = try await ClearTubeApp.invidiousClient.playlist(for: playlistId)
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

    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 50) {
                ForEach(model.videos, id: \.videoId) { video in
                    VideoCard(video: video)
                    .padding(30)
                }
            }.padding(50)
        }
        .navigationTitle(model.title ?? "Playlist")
        .asyncTaskOverlay(error: model.error, isLoading: model.loading)
        .task {
            await model.load()
        }.refreshable {
            await model.load()
        }.toolbar {
            if let url = URL(string: "https://youtube.com/playlist?list=\(model.playlistId)") {
                ToolbarItem {
                    #if !os(tvOS)
                    ShareLink(item: url)
                    #endif
                }
            } else {
                ToolbarItem {
                    Button {} label: {
                        Label("Share", systemImage: "square.and.arrow.up")
                    }.disabled(true)
                }
            }
        }
    }
}
