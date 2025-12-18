import SwiftUI

struct ProviderSidebar: View {
    @Binding var selectedProvider: LLMProvider
    let apiKeys: [LLMProvider: String]
    
    var body: some View {
        VStack(spacing: 8) {
            SidebarHeader()
            
            SidebarContent(
                selectedProvider: $selectedProvider,
                apiKeys: apiKeys
            )
            
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
    @Binding var selectedProvider: LLMProvider
    let apiKeys: [LLMProvider: String]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
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
            .padding(.horizontal, 16)
            .padding(.bottom, 12)
        }
    }
}
