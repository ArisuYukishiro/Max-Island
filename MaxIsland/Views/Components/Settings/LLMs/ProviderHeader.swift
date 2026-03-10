import SwiftUI

struct ProviderHeader: View {
    let provider: String
    
    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                Text(providerDisplayName(provider))
                    .font(.system(size: 20, weight: .semibold))
                    
                
                Text("Configure your \(providerDisplayName(provider)) integration")
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
            }
        }
        .padding(.bottom, 8)
    }
}

