import SwiftUI

struct ActiveModelBanner: View {
    let model: LLMModel
    let provider: LLMProvider
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 16))
                .foregroundColor(.green)
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Active Model")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.secondary)
                
                Text(model.name)
                    .font(.system(size: 14, weight: .medium))
            }
            
            Spacer()
            
            Text(provider.rawValue)
                .font(.system(size: 12))
                .foregroundColor(.secondary)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.accentColor.opacity(0.1))
                .cornerRadius(4)
        }
        .padding(12)
        .background(Color.green.opacity(0.1))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .strokeBorder(Color.green.opacity(0.3), lineWidth: 1)
        )
    }
}
