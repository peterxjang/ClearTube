import SwiftUI

struct PlaylistItemView: View {
    var id: String
    var title: String
    var thumbnail: String?
    var author: String
    var videoCount: Int

    var body: some View {
        let width = 500.0
        let height = width / 1.8

        VStack(alignment: .leading) {
            NavigationLink(destination: PlaylistView(model: PlaylistViewModel(playlistId: id))) {
                ZStack {
                    Group {
                        if let thumbnail, let url = URL(string: thumbnail) {
                            AsyncImage(url: url) { image in
                                image.resizable().scaledToFit()
                            } placeholder: {
                                ProgressView()
                            }
                        }
                    }
                    VideoThumbnailTag("\(videoCount.formatted()) videos")
                }
                .frame(width: width, height: height)
            }
            .buttonStyle(.card)

            Text(title).lineLimit(1).font(.callout)
            Text(author).lineLimit(1).foregroundStyle(.secondary).font(.callout)
        }.frame(width: width)
    }
}
