import Foundation

enum Environment {
    case development
    case staging
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
    // Base URLs for different environments
    private static let developmentURL = "https://max-api.arisusak.com"
    private static let stagingURL = "https://staging-api.yourapp.com"
    private static let productionURL = "https://api.yourapp.com"
    
    // Current base URL based on environment
    static let baseURL: String = {
        // First, check if custom URL is provided in Info.plist
        if let customURL = Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL") as? String,
           !customURL.isEmpty {
            return customURL
        }
        
        // Otherwise, use environment-based URL
        switch Environment.current {
        case .development:
            return developmentURL
        case .staging:
            return stagingURL
        case .production:
            return productionURL
        }
    }()
    
    // API Endpoints
    struct Endpoints {
        static let chat = "/chat"
        static let auth = "/auth"
        static let user = "/user"
    }
    
    // Timeout configuration
    static let timeoutInterval: TimeInterval = 30
    
    // Helper method to build full URL
    static func url(for endpoint: String) -> URL? {
        return URL(string: "\(baseURL)\(endpoint)")
    }
}

// MARK: - App Configuration
struct AppConfig {
    static let appName = "ChatApp"
    static let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    static let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
}
