import SwiftUI

struct APIKeySection: View {
    @ObservedObject var llmConfigManager: LLMConfigManager
    
    
    var currentApiKey: Binding<String> {
        Binding(
            get: { llmConfigManager.apiKeys[llmConfigManager.provider] ?? "" },
            set: { newValue in
                llmConfigManager.apiKeys[llmConfigManager.provider] = newValue
                llmConfigManager.saveConfigLLM()
            }
        )
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("API Key")
                .font(.system(size: 13, weight: .semibold))
            
            HStack {
                Group {
                    if llmConfigManager.showApiKey {
                        TextField("Enter your API key", text: currentApiKey)
                            .textFieldStyle(.roundedBorder)
                            .id("apikey-\(llmConfigManager.provider.rawValue)")
                    } else {
                        SecureField("Enter your API key", text: currentApiKey)
                            .textFieldStyle(.roundedBorder)
                            .id("apikey-\(llmConfigManager.provider.rawValue)")
                    }
                }
                .textFieldStyle(.roundedBorder)
                
                Button(action: { llmConfigManager.showApiKey.toggle() }) {
                    Image(systemName: llmConfigManager.showApiKey ? "eye.slash" : "eye")
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
    }
}
