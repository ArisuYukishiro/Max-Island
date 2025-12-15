import SwiftUI

struct LLMConfigSettingView: View {
    @State private var selectedProvider: LLMProvider = .claude
    @State private var apiKeys: [LLMProvider: String] = [:]
    @State private var selectedModel: String = "claude-sonnet-4.5"
    @State private var showApiKey = false
    
    var body: some View {
        HStack(spacing: 0) {
            ProviderSidebar(
                selectedProvider: $selectedProvider,
                apiKeys: apiKeys
            )
            
            Divider()
            
            ConfigurationPanel(
                selectedProvider: selectedProvider,
                selectedModel: $selectedModel,
                apiKeys: $apiKeys,
                showApiKey: $showApiKey,
                getProviderForModel: getProviderForModel,
                getActiveModel: getActiveModel
            )
        }
    }
    
    private func getProviderForModel(_ modelId: String) -> LLMProvider {
        for provider in LLMProvider.allCases {
            if provider.models.contains(where: { $0.id == modelId }) {
                return provider
            }
        }
        return selectedProvider
    }
    
    private func getActiveModel() -> LLMModel? {
        for provider in LLMProvider.allCases {
            if let model = provider.models.first(where: { $0.id == selectedModel }) {
                return model
            }
        }
        return nil
    }
}
