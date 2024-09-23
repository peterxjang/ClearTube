import SwiftUI

struct RootView: View {
    @State private var selectedTab = 0
    @State var search: String = ""

    var body: some View {
        TabView(selection: $selectedTab) {
            FeedView()
                .padding()
                .tabItem {
                    Label("Feed", systemImage: "star")
                }
                .tag(0)
            SavedVideosView()
                .padding()
                .tabItem {
                    Label("Saved", systemImage: "paperclip")
                }
                .tag(1)
            SubscriptionsView()
                .padding()
                .tabItem {
                    Label("Subscriptions", systemImage: "list.bullet")
                }
                .tag(2)
        }
        .searchable(text: $search, placement: .toolbar)
        .overlay {
            SearchResultsView(query: $search)
        }
        .toolbar {
            ToolbarItem {
                NavigationLink(destination: SettingsView()) {
                    Label("Settings", systemImage: "gear")
                }
            }
        }
    }
}
