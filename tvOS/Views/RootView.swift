import SwiftUI
import SwiftData

struct RootView: View {
    @State private var selectedTab = 0
    @State private var savedViewReloadTrigger = false

    var body: some View {
        TabView(selection: $selectedTab) {
            FeedView()
                .tabItem {
                    Text("Recent")
                }
                .tag(0)
            SavedVideosView(reloadTrigger: $savedViewReloadTrigger)
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
        .onChange(of: selectedTab) { oldValue, newValue in
            if newValue == 1 && oldValue != 1 {
                DispatchQueue.main.async {
                    savedViewReloadTrigger.toggle()
                }
            }
        }
    }
}
