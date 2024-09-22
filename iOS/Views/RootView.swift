import SwiftUI

struct RootView: View {
    @State var search: String = ""

    var body: some View {
        FeedView()
            .padding()
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
