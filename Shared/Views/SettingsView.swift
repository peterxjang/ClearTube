import SwiftUI

struct SettingsView: View {
    @Environment(Settings.self) var settings
    @Environment(\.modelContext) var modelContext

    var body: some View {
        @Bindable var settings = settings
        Form {
            Section {
                Button("Change Instance") {
                    settings.invidiousInstance = nil
                }
            } header: {
                Text("Instance")
            } footer: {
                VStack(alignment: .leading) {
                    Text("Current: \(settings.invidiousInstance ?? "")")
                    Spacer().frame(height: 10)
                    Text("Your settings and data are independent of the instance(s) you pick.")
                }
            }

            Section {
                Button("Delete all Watch Later", action: deleteAllWatchLater).tint(.red)
                Button("Delete all Recommended", action: deleteAllRecommended).tint(.red)
                Button("Delete all History", action: deleteAllHistory).tint(.red)
                Button("Erase All Content & Settings (except followed channels)") {
                    deleteAllWatchLater()
                    deleteAllRecommended()
                    deleteAllHistory()
                    settings.reset()
                }.tint(.red)
            } header: {
                Text("Storage")
            }
        }
        .navigationTitle("Settings")
    }

    func deleteAllWatchLater() {
        do {
            try modelContext.delete(model: WatchLaterVideo.self)
        } catch {
            print("Failed to delete watch later videos")
        }
    }

    func deleteAllRecommended() {
        do {
            try modelContext.delete(model: RecommendedVideo.self)
        } catch {
            print("Failed to delete recommended videos")
        }
    }

    func deleteAllHistory() {
        do {
            try modelContext.delete(model: HistoryVideo.self)
        } catch {
            print("Failed to delete history videos")
        }
    }
}
