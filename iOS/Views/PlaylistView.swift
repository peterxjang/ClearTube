import SwiftUI

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
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}
