import SwiftUI
import SwiftData

struct RootView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            FeedView()
                .tabItem {
                    Text("Feed")
                }
            SavedVideosView()
                .tabItem {
                    Text("Saved")
                }
            SubscriptionsView()
                .tabItem {
                    Text("Subscriptions")
                }
            SearchView()
                .tabItem {
                    Text("Search")
                }
            SettingsView()
                .tabItem {
                    Text("Settings")
                }
        }
    }
}
