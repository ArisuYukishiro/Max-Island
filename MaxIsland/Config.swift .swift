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
    private static let developmentURL = "http://localhost:8000"
    private static let productionURL = "https://max-api.arisusak.com"
    
    private static let chatAPIKey = "REDACTED_API_KEY"
    
    static let baseURL: String = {
        if let customURL = Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL") as? String {
            return customURL
        }
        
        switch Environment.current {
        case .development:
            return developmentURL
        case .staging:
            return productionURL
        case .production:
            return productionURL
        }
    }()
    
    static let apiKey: String = {
        if let plistKey = Bundle.main.object(forInfoDictionaryKey: "CHAT_API_KEY") as? String, !plistKey.isEmpty {
            return plistKey
        }
        
        return chatAPIKey
    }()

    struct Endpoints {
        static let chat = "/chat"
    }
    
    static let timeoutInterval: TimeInterval = 30
}
