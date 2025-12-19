import SwiftUI

struct ProviderSidebar: View {
    @ObservedObject var llmConfigManager: LLMConfigManager

    var body: some View {
        VStack(spacing: 8) {
            SidebarHeader()
            
            SidebarContent(llmConfigManager: llmConfigManager)

            Spacer()
        }
        .frame(height: 80)
        .cornerRadius(16)
    }
}

private struct SidebarHeader: View {
    var body: some View {
        HStack {
            Text("Providers")
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(.secondary)
                .padding(.leading, 16)
            
            Spacer()
        }
        .padding(.top, 12)
    }
}


private struct SidebarContent: View {
    @ObservedObject var llmConfigManager: LLMConfigManager

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(llmConfigManager.getProviders(), id: \.self) { provider in
                    ProviderButton(
                        provider: provider,
                        isSelected: llmConfigManager.selectedProvider == provider,
                        hasApiKey: llmConfigManager.apiKeys[provider]?.isEmpty == false
                    ) {
                        llmConfigManager.selectedProvider = provider
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 12)
        }
    }
}
