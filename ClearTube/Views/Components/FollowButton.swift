import SwiftUI
import SwiftData

struct FollowButton: View {
    var channel: ChannelObject
    @Environment(\.modelContext) private var context
    @State var isFollowed: Bool = false
    @State var loading = true

    var body: some View {
        Button {
            if isFollowed {
                // FIXME: handle failure
                do {
                    let authorId = channel.authorId
                    try context.delete(
                        model: FollowedChannel.self,
                        where: #Predicate { $0.authorId == authorId }
                    )
                    self.isFollowed = false
                } catch {}
            } else {
                context.insert(
                    FollowedChannel(channel: channel)
                )
                self.isFollowed = true
            }
        } label: {
            if self.isFollowed {
                Label("Unfollow", systemImage: "heart.fill")
            } else {
                Label("Follow", systemImage: "heart")
            }
        }.disabled(loading).onAppear {
            do {
                loading = true
                let authorId = channel.authorId
                let request = FetchDescriptor<FollowedChannel>(predicate: #Predicate { $0.authorId == authorId })
                let count = try context.fetchCount(request)
                isFollowed = count > 0
            } catch {
                // FIXME: handle failure
            }
            self.loading = false
        }
    }
}
