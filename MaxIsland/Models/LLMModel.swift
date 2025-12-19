import SwiftUI

struct LLMModel: Identifiable, Codable  {
    let id: String
    let name: String
    let description: String
    let key: String?
}


func providerDisplayName(_ provider: String) -> String {
    switch provider.lowercased() {
    case "openai":
        return "OpenAI"
    case "groq":
        return "Groq"
    case "anthropic":
        return "Anthropic"
    case "gemini":
        return "Gemini"
    default:
        return provider.capitalized
    }
}
