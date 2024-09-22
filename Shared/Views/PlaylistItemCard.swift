import SwiftUI

struct PlaylistItemCard: View {
    var playlist: PlaylistObject
    var width: CGFloat = 500.0

    var body: some View {
        let height = width / 1.8

        VStack(alignment: .leading) {
            NavigationLink(
                destination: PlaylistView(
                    model: PlaylistViewModel(playlistId: playlist.playlistId)
                )
            ) {
                ZStack {
                    Group {
                        if let thumbnail = playlist.playlistThumbnail, let url = URL(string: thumbnail) {
                            AsyncImage(url: url) { image in
                                image.resizable().scaledToFit()
                            } placeholder: {
                                ProgressView()
                            }
                        }
                    }
                    VideoThumbnailTag("\(playlist.videoCount.formatted()) videos")
                }
                .frame(width: width, height: height)
            }
            #if os(tvOS)
            .buttonStyle(.card)
            #endif

            Text(playlist.title).lineLimit(1).font(.callout)
            Text(playlist.author).lineLimit(1).foregroundStyle(.secondary).font(.callout)
        }.frame(width: width)
    }
}
