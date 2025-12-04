import Foundation

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case decodingError
    case serverError(String)
}

class ChatAPIService {
    private let baseURL = APIConfig.baseURL
    
    func sendMessage(_ message: String) async throws -> String {
        guard let url = URL(string: "\(baseURL)\(APIConfig.Endpoints.chat)") else {
            throw APIError.invalidURL
        }
        
        #if DEBUG
        print("🌐 API Request URL: \(url.absoluteString)")
        print("📤 Sending message: \(message)")
        #endif
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = APIConfig.timeoutInterval
        
        let chatRequest = ChatRequest(message: message)
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
            print("✅ Response received: \(chatResponse.response)")
            #endif
            return chatResponse.response
        } catch {
            #if DEBUG
            print("❌ Decoding error: \(error)")
            #endif
            throw APIError.decodingError
        }
    }
}
