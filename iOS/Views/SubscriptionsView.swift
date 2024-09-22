import SwiftData
import SwiftUI

struct SubscriptionsView: View {
    @Query(sort: \FollowedChannel.author) var channels: [FollowedChannel]
    @State private var selectedChannel: FollowedChannel? = nil
    var resetView: Bool = false

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                if channels.isEmpty {
                    MessageBlock(
                        title: "You aren't following any channels.",
                        message: "Search for channels you'd like to follow."
                    ).padding(.horizontal)
                } else {
                    VStack(alignment: .leading) {
                        ForEach(channels) { channel in
                            NavigationLink(destination: ChannelView(channelId: channel.authorId)) {
                                HStack {
                                    PreferredImage(
                                        width: 50,
                                        height: 50,
                                        images: [
                                            ImageObject(
                                                url: channel.thumbnailUrl ?? "",
                                                width: channel.thumbnailWidth ?? 0,
                                                height: channel.thumbnailHeight ?? 0
                                            )
                                        ]
                                    )
                                    Text(channel.author)
                                        .padding()
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .padding(.trailing)
                                }
                            }
                            .padding(10)
                        }
                    }
                }
            }
        }
        .id(resetView)
    }
}
