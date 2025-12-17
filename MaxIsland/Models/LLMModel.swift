import SwiftUI

enum LLMProvider: String, CaseIterable {
    case claude = "Claude"
    case openai = "OpenAI"
    case gemini = "Gemini"
    case groq = "Groq"
    
    var icon: String {
        switch self {
        case .claude: return "brain.head.profile"
        case .openai: return "cpu"
        case .gemini: return "sparkles"
        case .groq: return "bolt.fill"
        }
    }
    
    var models: [LLMModel] {
        switch self {
        case .claude:
            return [
                LLMModel(id: "claude-sonnet-4.5", name: "Claude Sonnet 4.5", description: "Most intelligent model", key: ""),
                LLMModel(id: "claude-opus-4", name: "Claude Opus 4", description: "Powerful model for complex tasks", key: ""),
                LLMModel(id: "claude-haiku-4", name: "Claude Haiku 4", description: "Fast and efficient", key: "")
            ]
        case .openai:
            return [
                LLMModel(id: "gpt-4-turbo", name: "GPT-4 Turbo", description: "Most capable GPT-4 model", key: ""),
                LLMModel(id: "gpt-4", name: "GPT-4", description: "Standard GPT-4", key: ""),
                LLMModel(id: "gpt-3.5-turbo", name: "GPT-3.5 Turbo", description: "Fast and cost-effective", key: "")
            ]
        case .gemini:
            return [
                LLMModel(id: "gemini-pro", name: "Gemini Pro", description: "Best for complex tasks", key: ""),
                LLMModel(id: "gemini-pro-vision", name: "Gemini Pro Vision", description: "Multimodal capabilities", key: ""),
                LLMModel(id: "gemini-ultra", name: "Gemini Ultra", description: "Most capable model", key: "")
            ]
        case .groq:
            return [
                LLMModel(id: "llama-3-70b", name: "LLaMA 3 70B", description: "High performance", key: ""),
                LLMModel(id: "mixtral-8x7b", name: "Mixtral 8x7B", description: "Mixture of experts", key: ""),
                LLMModel(id: "gemma-7b", name: "Gemma 7B", description: "Lightweight model", key: "")
            ]
        }
    }
}

struct LLMModel: Identifiable, Codable  {
    let id: String
    let name: String
    let description: String
    let key: String?
}
