import Foundation

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case decodingError
    case serverError(String)
    case missingAPIKey
    case providerNotFound(String)
    case modelNotFound(String)
}

class ChatAPIService {
    private let baseURL = APIConfig.baseURL
    private let llmConfigManager: LLMConfigManager
    
    init(llmConfigManager: LLMConfigManager) {
        self.llmConfigManager = llmConfigManager
    }
    
    func sendMessage(_ message: String) async throws -> String {
        
        guard !llmConfigManager.currentAPIKey.isEmpty else {
              throw APIError.missingAPIKey
        }
        
        let modelName = llmConfigManager.selectedModel
        let provider = llmConfigManager.selectedProvider
        let apiKey = llmConfigManager.currentAPIKey
        
        
        var urlComponents = URLComponents(string: "\(baseURL)\(APIConfig.Endpoints.chat)")
            urlComponents?.queryItems = [
                URLQueryItem(name: "model_name", value: modelName),
                URLQueryItem(name: "provider", value: provider)
            ]

        guard let url = urlComponents?.url else {
            throw APIError.invalidURL
        }
        
        #if DEBUG
        print("API Request URL: \(url.absoluteString)")
        print("Sending message: \(message)")
        print("Model: \(modelName)")
        print("Provider: \(provider)")
        print("API Key:\(apiKey)")
        #endif
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(apiKey, forHTTPHeaderField: "API-KEY")
        request.timeoutInterval = APIConfig.timeoutInterval
        
        let chatRequest = ChatRequest(
            message: message,
        )
        request.httpBody = try JSONEncoder().encode(chatRequest)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        #if DEBUG
        print("📥 Response Status: \(httpResponse.statusCode)")
        #endif
        
        guard (200...299).contains(httpResponse.statusCode) else {
            let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw APIError.serverError(errorMessage)
        }
        
        do {
            let chatResponse = try JSONDecoder().decode(ChatResponse.self, from: data)
            #if DEBUG
            print("Response received: \(chatResponse.response)")
            #endif
            return chatResponse.response
        } catch {
            #if DEBUG
            print("Decoding error: \(error)")
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw response: \(jsonString)")
            }
            #endif
            throw APIError.decodingError
        }
    }
}
