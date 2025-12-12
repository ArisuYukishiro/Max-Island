import SwiftUI

// MARK: - Models
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
                LLMModel(id: "claude-sonnet-4.5", name: "Claude Sonnet 4.5", description: "Most intelligent model"),
                LLMModel(id: "claude-opus-4", name: "Claude Opus 4", description: "Powerful model for complex tasks"),
                LLMModel(id: "claude-haiku-4", name: "Claude Haiku 4", description: "Fast and efficient")
            ]
        case .openai:
            return [
                LLMModel(id: "gpt-4-turbo", name: "GPT-4 Turbo", description: "Most capable GPT-4 model"),
                LLMModel(id: "gpt-4", name: "GPT-4", description: "Standard GPT-4"),
                LLMModel(id: "gpt-3.5-turbo", name: "GPT-3.5 Turbo", description: "Fast and cost-effective")
            ]
        case .gemini:
            return [
                LLMModel(id: "gemini-pro", name: "Gemini Pro", description: "Best for complex tasks"),
                LLMModel(id: "gemini-pro-vision", name: "Gemini Pro Vision", description: "Multimodal capabilities"),
                LLMModel(id: "gemini-ultra", name: "Gemini Ultra", description: "Most capable model")
            ]
        case .groq:
            return [
                LLMModel(id: "llama-3-70b", name: "LLaMA 3 70B", description: "High performance"),
                LLMModel(id: "mixtral-8x7b", name: "Mixtral 8x7B", description: "Mixture of experts"),
                LLMModel(id: "gemma-7b", name: "Gemma 7B", description: "Lightweight model")
            ]
        }
    }
}

struct LLMModel: Identifiable {
    let id: String
    let name: String
    let description: String
}

// MARK: - Main View
struct LLMConfigSettingView: View {
    @State private var selectedProvider: LLMProvider = .claude
    @State private var apiKeys: [LLMProvider: String] = [:]
    @State private var selectedModel: String = "claude-sonnet-4.5"
    @State private var showApiKey = false
    
    var body: some View {
        HStack(spacing: 0) {
            // Provider Selection Sidebar
            providerSidebar
            
            Divider()
            
            // Configuration Panel
            configurationPanel
        }
    }
    
    // Helper function to get provider for a model
    private func getProviderForModel(_ modelId: String) -> LLMProvider {
        for provider in LLMProvider.allCases {
            if provider.models.contains(where: { $0.id == modelId }) {
                return provider
            }
        }
        return selectedProvider
    }
    
    // Helper function to get active model details
    private func getActiveModel() -> LLMModel? {
        for provider in LLMProvider.allCases {
            if let model = provider.models.first(where: { $0.id == selectedModel }) {
                return model
            }
        }
        return nil
    }
    
    // MARK: - Provider Sidebar
    private var providerSidebar: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Providers")
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(.secondary)
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 8)
            
            ScrollView {
                VStack(spacing: 4) {
                    ForEach(LLMProvider.allCases, id: \.self) { provider in
                        ProviderButton(
                            provider: provider,
                            isSelected: selectedProvider == provider,
                            hasApiKey: apiKeys[provider]?.isEmpty == false
                        ) {
                            selectedProvider = provider
                        }
                    }
                }
                .padding(.horizontal, 8)
            }
            
            Spacer()
        }
        .frame(width: 200)
//        .background(Color(nsColor: .controlBackgroundColor))
    }
    
    // MARK: - Configuration Panel
    private var configurationPanel: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Active Model Banner
                if let activeModel = getActiveModel() {
                    HStack(spacing: 12) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.green)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Active Model")
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundColor(.secondary)
                            
                            Text(activeModel.name)
                                .font(.system(size: 14, weight: .medium))
                        }
                        
                        Spacer()
                        
                        Text(getProviderForModel(selectedModel).rawValue)
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.accentColor.opacity(0.1))
                            .cornerRadius(4)
                    }
                    .padding(12)
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .strokeBorder(Color.green.opacity(0.3), lineWidth: 1)
                    )
                }
                
                // Header
                HStack(spacing: 12) {
                    Image(systemName: selectedProvider.icon)
                        .font(.system(size: 24))
                        .foregroundColor(.accentColor)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(selectedProvider.rawValue)
                            .font(.system(size: 20, weight: .semibold))
                        
                        Text("Configure your \(selectedProvider.rawValue) integration")
                            .font(.system(size: 13))
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.bottom, 8)
                
                // API Key Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("API Key")
                        .font(.system(size: 13, weight: .semibold))
                    
                    HStack {
                        Group {
                            if showApiKey {
                                TextField("Enter your API key", text: Binding(
                                    get: { apiKeys[selectedProvider] ?? "" },
                                    set: { apiKeys[selectedProvider] = $0 }
                                ))
                            } else {
                                SecureField("Enter your API key", text: Binding(
                                    get: { apiKeys[selectedProvider] ?? "" },
                                    set: { apiKeys[selectedProvider] = $0 }
                                ))
                            }
                        }
                        .textFieldStyle(.roundedBorder)
                        
                        Button(action: { showApiKey.toggle() }) {
                            Image(systemName: showApiKey ? "eye.slash" : "eye")
                                .foregroundColor(.secondary)
                        }
                        .buttonStyle(.plain)
                    }
                    
                    Text("Your API key is stored securely and never shared")
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                }
                .padding(16)
                .background(Color(nsColor: .controlBackgroundColor))
                .cornerRadius(8)
                
                // Model Selection Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Available Models")
                        .font(.system(size: 13, weight: .semibold))
                    
                    Text("Select a model to use for your chats")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                    
                    VStack(spacing: 8) {
                        ForEach(selectedProvider.models) { model in
                            ModelRow(
                                model: model,
                                isSelected: selectedModel == model.id
                            ) {
                                selectedModel = model.id
                                selectedProvider = getProviderForModel(model.id)
                            }
                        }
                    }
                }
                .padding(16)
                .background(Color(nsColor: .controlBackgroundColor))
                .cornerRadius(8)
                
                // Action Buttons
                HStack(spacing: 12) {
                    Button("Test Connection") {
                        // Test connection action
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button("Save Configuration") {
                        // Save action
                    }
                    
                    Spacer()
                }
            }
            .padding(24)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Provider Button
    struct ProviderButton: View {
        let provider: LLMProvider
        let isSelected: Bool
        let hasApiKey: Bool
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                HStack(spacing: 10) {
                    Image(systemName: provider.icon)
                        .font(.system(size: 14))
                        .frame(width: 20)
                        .foregroundColor(isSelected ? .accentColor : .secondary)
                    
                    Text(provider.rawValue)
                        .font(.system(size: 13))
                    
                    Spacer()
                    
                    if hasApiKey {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 6, height: 6)
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    isSelected ?
                    Color.accentColor.opacity(0.15) :
                        Color.clear
                )
                .cornerRadius(6)
            }
            .buttonStyle(.plain)
        }
    }
    
    // MARK: - Model Row
    struct ModelRow: View {
        let model: LLMModel
        let isSelected: Bool
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                HStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(model.name)
                            .font(.system(size: 13, weight: .medium))
                        
                        Text(model.description)
                            .font(.system(size: 11))
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    ZStack {
                        Circle()
                            .strokeBorder(isSelected ? Color.accentColor : Color.secondary.opacity(0.3), lineWidth: 2)
                            .frame(width: 20, height: 20)
                        
                        if isSelected {
                            Circle()
                                .fill(Color.accentColor)
                                .frame(width: 12, height: 12)
                        }
                    }
                }
                .padding(12)
                .background(
                    isSelected ?
                    Color.accentColor.opacity(0.1) :
                        Color(nsColor: .separatorColor).opacity(0.1)
                )
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(
                            isSelected ? Color.accentColor.opacity(0.3) : Color.clear,
                            lineWidth: 1
                        )
                )
            }
            .buttonStyle(.plain)
        }
    }
}
