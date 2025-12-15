import SwiftUI

struct APIKeySection: View {
    let provider: LLMProvider
    @Binding var apiKeys: [LLMProvider: String]
    @Binding var showApiKey: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("API Key")
                .font(.system(size: 13, weight: .semibold))
            
            HStack {
                Group {
                    if showApiKey {
                        TextField("Enter your API key", text: Binding(
                            get: { apiKeys[provider] ?? "" },
                            set: { apiKeys[provider] = $0 }
                        ))
                    } else {
                        SecureField("Enter your API key", text: Binding(
                            get: { apiKeys[provider] ?? "" },
                            set: { apiKeys[provider] = $0 }
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
    }
}
