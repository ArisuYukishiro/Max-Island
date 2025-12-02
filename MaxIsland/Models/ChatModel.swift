import Foundation

struct Message: Identifiable, Codable {
    let id = UUID()
    let text: String
    let isUser: Bool
}

struct ChatRequest: Codable {
    let message: String
}

struct ChatResponse: Codable {
    let response: String
}
