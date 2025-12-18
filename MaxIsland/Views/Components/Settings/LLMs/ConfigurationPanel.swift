import SwiftUI

struct ConfigurationPanel: View {
    let selectedProvider: LLMProvider
    @Binding var selectedModel: String
    @Binding var apiKeys: [LLMProvider: String]
    @Binding var showApiKey: Bool
    let getProviderForModel: (String) -> LLMProvider
    let getActiveModel: () -> LLMModel?
    
    var body: some View {
            VStack(alignment: .leading, spacing: 24) {
                if let activeModel = getActiveModel() {
                    ActiveModelBanner(
                        model: activeModel,
                        provider: getProviderForModel(selectedModel)
                    )
                }
                
                ProviderHeader(provider: selectedProvider)
                
                APIKeySection(
                    provider: selectedProvider,
                    apiKeys: $apiKeys,
                    showApiKey: $showApiKey
                )
                
                ModelSelectionSection(
                    provider: selectedProvider,
                    selectedModel: $selectedModel,
                    getProviderForModel: getProviderForModel
                )
                
                ActionButtons()
            }
            .padding(24)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}
