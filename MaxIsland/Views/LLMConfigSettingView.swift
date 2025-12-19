import SwiftUI

struct LLMConfigSettingView: View {
    @StateObject private var llmConfigManager = LLMConfigManager()
    @State private var showApiKey = false

    var body: some View {
        VStack(spacing: 0) {
            ProviderSidebar(llmConfigManager: llmConfigManager)
            
            Divider()
            
            ScrollView(.vertical, showsIndicators: true) {
                ConfigurationPanel(
                    showApiKey: $showApiKey,
                    llmConfigManager: llmConfigManager
                ).environmentObject(llmConfigManager)
            }
        }
        .onAppear {
                 llmConfigManager.loadConfigLLM()
                 llmConfigManager.printAllVariables()
        }
    }
}
