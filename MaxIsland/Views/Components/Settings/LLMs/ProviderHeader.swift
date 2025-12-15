import SwiftUI

struct ProviderHeader: View {
    let provider: LLMProvider
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: provider.icon)
                .font(.system(size: 24))
                .foregroundColor(.accentColor)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(provider.rawValue)
                    .font(.system(size: 20, weight: .semibold))
                
                Text("Configure your \(provider.rawValue) integration")
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
            }
        }
        .padding(.bottom, 8)
    }
}
