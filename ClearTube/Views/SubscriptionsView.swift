import SwiftData
import SwiftUI

struct SubscriptionsView: View {
    @Query(sort: \FollowedChannel.name) var channels: [FollowedChannel]
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
                            NavigationLink(destination: ChannelView(model: ChannelViewModel(channelId: channel.id))) {
                                HStack {
                                    Text(channel.name)
                                        .padding()
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .padding(.trailing)
                                }
                            }
                        }
                    }
                }
            }.padding(50)
        }
        .id(resetView)
    }
}
