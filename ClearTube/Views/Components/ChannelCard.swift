import SwiftUI

struct ChannelCard: View {
    var channel: ChannelObject
    @State private var showChannelView = false

    var body: some View {
        NavigationLink(destination: ChannelView(model: ChannelViewModel(channelId: channel.authorId))) {
            VStack {
                PreferredImage(width: 200, height: 200, images: channel.authorThumbnails)
                Text(channel.author)
                Text(channel.subCountTextDisplay())
                    .font(.callout)
                    .foregroundStyle(.secondary)
            }
            .frame(maxHeight: 400)
        }
    }
}
