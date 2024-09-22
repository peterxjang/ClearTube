import SwiftUI
import SwiftData

@main
struct ClearTubeApp: App {
    static var invidiousClient = InvidiousAPI()
    static var innerTubeClient = InnerTubeAPI()
    var settings = Settings()
    @State var hasValidInstance: Bool? = nil

    var body: some Scene {
        WindowGroup {
            ZStack {
                switch hasValidInstance {
                case .some(true):
                    NavigationStack {
                        RootView()
                    }
                case .some(false):
                    OnboardingView(hasValidInstance: $hasValidInstance)
                case .none:
                    ProgressView()
                        .task {
                            await validateInstance()
                        }
                }
            }
        }
        .modelContainer(
            for: [
                FollowedChannel.self,
                WatchLaterVideo.self,
                RecommendedVideo.self,
                HistoryVideo.self
            ]
        )
        .environment(settings)
        .onChange(of: settings.invidiousInstance) {
            Task {
                await validateInstance()
            }
        }
    }

    func validateInstance() async {
        guard
            let instanceUrlString = settings.invidiousInstance,
            let instanceUrl = URL(string: instanceUrlString)
        else {
            await MainActor.run {
                ClearTubeApp.invidiousClient.setApiUrl(url: nil)
                hasValidInstance = false
            }
            return
        }
        let response = await InvidiousAPI.isValidInstance(url: instanceUrl)
        await MainActor.run {
            if response {
                ClearTubeApp.invidiousClient.setApiUrl(url: instanceUrl)
            }
            hasValidInstance = response
        }
    }
}
