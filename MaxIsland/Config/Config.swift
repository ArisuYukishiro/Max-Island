import Foundation

// MARK: - Environment
// Secrets are loaded from Secrets.xcconfig (gitignored).
// Copy Secrets.xcconfig.example → Secrets.xcconfig and fill in real values.

enum Environment {
    case development
    case production

    static var current: Environment {
        #if DEBUG
        return .development
        #else
        return .production
        #endif
    }
}


struct APIConfig {

    /// Base URL injected via Secrets.xcconfig → Info.plist → Bundle at build time.
    static let baseURL: String = {
        guard let url = Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL") as? String,
              !url.isEmpty else {
            #if DEBUG
            let raw = Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL")
            print("API_BASE_URL raw value:", raw as Any)
            assertionFailure("API_BASE_URL is missing. Copy Secrets.xcconfig.example → Secrets.xcconfig and set a value.")
            #endif
            return ""
        }
        print("[APIConfig] API_BASE_URL:", url)
        return url
    }()

    struct Endpoints {
        static let chat = "/chat"
        static let providerAndModels = "/models"
    }

    static let timeoutInterval: TimeInterval = 30
}
