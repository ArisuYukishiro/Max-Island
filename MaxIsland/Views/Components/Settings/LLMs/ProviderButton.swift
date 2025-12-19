import SwiftUI

struct ProviderButton: View {
    let provider: String
    let isSelected: Bool
    let hasApiKey: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {

                Text(providerDisplayName(provider))
                    .font(.system(size: 13))
                
                Spacer()
                
                if hasApiKey {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 6, height: 6)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                isSelected ?
                Color.accentColor.opacity(0.15) :
                    Color.clear
            )
            .cornerRadius(6)
        }
        .buttonStyle(.plain)
    }
}
