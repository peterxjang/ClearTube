import SwiftUI

struct ChannelCard: View {
    var channel: ChannelObject
    var width: CGFloat = 400.0
    @State private var showChannelView = false

    var body: some View {
        NavigationLink(destination: ChannelView(channelId: channel.authorId)) {
            VStack {
                PreferredImage(width: 200, height: 200, images: channel.authorThumbnails)
                Text(channel.author)
                Text(channel.subCountTextDisplay())
                    .font(.callout)
                    .foregroundStyle(.secondary)
            }
            .frame(width: width)
        }
    }
}
