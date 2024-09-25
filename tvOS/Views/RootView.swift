import SwiftUI
import SwiftData

struct RootView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            FeedView()
                .tabItem {
                    Text("Recent")
                }
                .tag(0)
            SavedVideosView()
                .tabItem {
                    Text("Saved")
                }
                .tag(1)
            SubscriptionsView()
                .tabItem {
                    Text("Channels")
                }
                .tag(2)
            SearchView()
                .tabItem {
                    Text("Search")
                }
                .tag(3)
            SettingsView()
                .tabItem {
                    Text("Settings")
                }
                .tag(4)
        }
    }
}
