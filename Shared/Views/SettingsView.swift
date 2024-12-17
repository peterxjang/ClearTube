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
                Button {
                    Task{
                          await resetFollowedChannels()
                        }
                  } label: {
                          Text("Reset followed channels")
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

    func resetFollowedChannels() async {
        let authorIds = [
            "6figga_dilla", "AdamWitt", "apartmenttherapy", "JiBbo", "bigthink",
            "Caroline_Winkler", "CityBeautiful", "CNBCMakeIt", "DamiLeeArch", "DanielTitchener",
            "DearModern", "diggingthegreats", "DIYPerks", "ExplainedwithDom", "DarrenVanDam",
            "fourth_place", "halfasinteresting", "HomeByMon", "houseandhome", "ironchefdad",
            "jetbentlee", "KimchiAndBeansVideos", "KristenMcGowan", "LetterboxdHQ", "LivingK",
            "MartyMusic", "nevertoosmall", "Nick_Lewis", "noahdaniel.studio", "OhTheUrbanity",
            "wasselpa", "PaulDavids", "CityNerd", "ReNiCGaming", "reynardlowell", "RickBeato",
            "StavvyBaby", "TheDailyConversation", "Techmoan", "TechnologyConnections", "TheB1M",
            "TheHustleChannel", "wsj", "PoshPennies", "Vox", "crystal_cube99"
        ]
        do {
            try await MainActor.run {
                try modelContext.delete(model: FollowedChannel.self)
            }
            await withTaskGroup(of: Void.self) { group in
                for authorId in authorIds {
                    group.addTask {
                        do {
                            var response: [SearchObject.Result]
                            do {
                                response = try await ClearTubeApp.invidiousClient.search(query: "@\(authorId)", page: 0)
                            } catch {
                                print("InvidiousClient failed, trying InnerTubeClient: \(error)")
                                response = try await ClearTubeApp.innerTubeClient.search(query: "@\(authorId)", page: 0)
                            }

                            for result in response {
                                if case .channel(let channel) = result {
                                    await MainActor.run {
                                        modelContext.insert(FollowedChannel(channel: channel))
                                        print("Inserted channel: \(channel)")
                                    }
                                    break
                                }
                            }
                        } catch {
                            print("Error processing authorId \(authorId): \(error)")
                        }
                    }
                }
            }
        } catch {
            print("Error resetting followed channels: \(error)")
        }
    }
}
