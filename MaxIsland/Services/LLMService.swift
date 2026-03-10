import Foundation

struct ModelInfo: Codable {
    let displayName: String
    let modelName: String
    
    enum CodingKeys: String, CodingKey {
        case displayName = "display_name"
        case modelName = "model_name"
    }
}

struct APIResponse: Codable {
    let message: String
    let data: [String: [ModelInfo]]
}

struct ProviderInfo {
    let name: String
    let models: [ModelInfo]
    
    var modelCount: Int {
        return models.count
    }
    
    var modelNames: [String] {
        return models.map { $0.modelName }
    }
    
    var displayNames: [String] {
        return models.map { $0.displayName }
    }
}

class LLMService {
    private let baseURL = APIConfig.baseURL
    private let llmConfigManager: LLMConfigManager
    
    init(llmConfigManager: LLMConfigManager) {
        self.llmConfigManager = llmConfigManager
    }
    
    func getProviderAndModel() async throws -> [String: [ModelInfo]] {
        guard let url = URL(string: baseURL + APIConfig.Endpoints.providerAndModels) else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (responseData, urlResponse) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = urlResponse as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIError.serverError(httpResponse.description)
        }
        
        let decoder = JSONDecoder()
        do {
            let apiResponse = try decoder.decode(APIResponse.self, from: responseData)
            
            llmConfigManager.updateProviders(apiResponse.data)
            
            return apiResponse.data
        } catch {
            throw APIError.decodingError
        }
    }
}
