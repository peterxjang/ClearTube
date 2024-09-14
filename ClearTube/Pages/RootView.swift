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
            Text("Placeholder saved")
                .tabItem {
                    Text("Saved")
                }
            Text("Placeholder subscriptions")
                .tabItem {
                    Text("Subscriptions")
                }
            Text("Placeholder search")
                .tabItem {
                    Text("Search")
                }
            Text("Placeholder settings")
                .tabItem {
                    Text("Settings")
                }
        }
    }
}
