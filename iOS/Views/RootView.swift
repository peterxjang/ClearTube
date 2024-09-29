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
    @State private var savedViewReloadTrigger = false
    @Environment(\.dismissSearch) var dismissSearch

    var body: some View {
        TabView(selection: $selectedTab) {
            FeedView()
                .padding()
                .tabItem {
                    Label("Recent", systemImage: "list.bullet")
                }
                .tag(0)
            SavedVideosView(reloadTrigger: $savedViewReloadTrigger)
                .padding()
                .tabItem {
                    Label("Saved", systemImage: "paperclip")
                }
                .tag(1)
            SubscriptionsView()
                .padding()
                .tabItem {
                    Label("Channels", systemImage: "star")
                }
                .tag(2)
        }
        .onChange(of: selectedTab) { oldValue, newValue in
            if newValue == 1 && oldValue != 1 {
                DispatchQueue.main.async {
                    savedViewReloadTrigger.toggle()
                }
            }
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
