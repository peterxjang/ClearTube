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
                Button("Unfollow All Channels", action: unfollowAllChannels).tint(.red)
                Button("Erase All Content & Settings") {
                    unfollowAllChannels()
                    settings.reset()
                }.tint(.red)
            } header: {
                Text("Storage")
            }
        }
        .navigationTitle("Settings")
    }

    func unfollowAllChannels() {
        print("unFollowAllChannels")
    }
}
