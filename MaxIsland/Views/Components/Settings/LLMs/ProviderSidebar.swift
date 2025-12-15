import SwiftUI

struct ProviderSidebar: View {
    @Binding var selectedProvider: LLMProvider
    let apiKeys: [LLMProvider: String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            SidebarHeader()
            
            SidebarContent(
                selectedProvider: $selectedProvider,
                apiKeys: apiKeys
            )
            
            Spacer()
        }
        .frame(width: 200)
    }
}

private struct SidebarHeader: View {
    var body: some View {
        Text("Providers")
            .font(.system(size: 11, weight: .semibold))
            .foregroundColor(.secondary)
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 8)
    }
}

private struct SidebarContent: View {
    @Binding var selectedProvider: LLMProvider
    let apiKeys: [LLMProvider: String]
    
    var body: some View {
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
    }
}
