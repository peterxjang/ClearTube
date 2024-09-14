import SwiftUI
import SwiftData

@main
struct ClearTubeApp: App {
    static var client = InvidiousAPI()
    var settings = Settings()
    @State var hasValidInstance: Bool? = nil

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

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
