import SwiftUI
import SwiftData

@main
struct ClearTubeApp: App {
    static var client = InvidiousAPI()
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
                FollowedChannel.self
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
                Self.client.setApiUrl(url: nil)
                hasValidInstance = false
            }
            return
        }
        let response = await InvidiousAPI.isValidInstance(url: instanceUrl)
        await MainActor.run {
            if response {
                Self.client.setApiUrl(url: instanceUrl)
            }
            hasValidInstance = response
        }
    }
}
