import SwiftUI

struct ConfigurationPanel: View {
    @Binding var showApiKey: Bool
    @ObservedObject var llmConfigManager: LLMConfigManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            if let activeModel = llmConfigManager.getActiveModel() {
                ActiveModelBanner(
                    model: activeModel,
                    provider: llmConfigManager.getProviderForModel(llmConfigManager.selectedModel) ?? llmConfigManager.selectedProvider                )
            }
            
            ProviderHeader(provider: llmConfigManager.selectedProvider)
            
            APIKeySection(
                llmConfigManager: llmConfigManager
            )
            
            ModelSelectionSection(
                llmConfigManager: llmConfigManager
            )
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .onAppear {
            llmConfigManager.loadConfigLLM()
        }
        .onChange(of: llmConfigManager.selectedProvider) { oldValue, newValue in
            llmConfigManager.saveConfigLLM()
        }
        .onChange(of: llmConfigManager.selectedModel) { oldValue, newValue in
            llmConfigManager.saveConfigLLM()
        }
        .onChange(of: llmConfigManager.apiKeys) { oldValue, newValue in
            llmConfigManager.saveConfigLLM()
        }
    }
}
