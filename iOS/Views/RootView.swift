import SwiftUI

struct RootView: View {
    @State var search: String = ""

    var body: some View {
        MainView(search: search)
            .searchable(text: $search, placement: .toolbar)
            .overlay {
                SearchResultsView(query: $search)
            }
    }
}

struct MainView: View {
    let search: String
    @State private var selectedTab = 0
    @Environment(\.dismissSearch) var dismissSearch

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
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                if !search.isEmpty {
                    Button(action: {
                        dismissSearch()
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                    }
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: SettingsView()) {
                    Label("Settings", systemImage: "gear")
                }
            }
        }
    }
}
