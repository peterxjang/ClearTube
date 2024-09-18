import Foundation

struct RequestBody: Codable {
    let context: Context
    struct Context: Codable {
        let client: Client
        struct Client: Codable {
            let clientName: String
            let clientVersion: String
            let hl: String
            let gl: String
            let deviceMake: String?
            let deviceModel: String?
            let experimentIds: [String]
            let utcOffsetMinutes: Int
        }
        let user: User
        struct User: Codable {
            let lockedSafetyMode: Bool
        }
        let request: RequestContext
        struct RequestContext: Codable {
            let useSsl: Bool
            let internalExperimentFlags: [String]
            let consistencyTokenJars: [String]
        }
    }
}
