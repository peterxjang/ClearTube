import SwiftUI

struct VideoPlayer: View {
    var video: VideoObject

    var body: some View {
        Text(video.title)
    }
}
