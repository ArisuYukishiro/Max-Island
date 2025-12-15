import SwiftUI

struct ModelRow: View {
    let model: LLMModel
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(model.name)
                        .font(.system(size: 13, weight: .medium))
                    
                    Text(model.description)
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                ZStack {
                    Circle()
                        .strokeBorder(isSelected ? Color.accentColor : Color.secondary.opacity(0.3), lineWidth: 2)
                        .frame(width: 20, height: 20)
                    
                    if isSelected {
                        Circle()
                            .fill(Color.accentColor)
                            .frame(width: 12, height: 12)
                    }
                }
            }
            .padding(12)
            .background(
                isSelected ?
                Color.accentColor.opacity(0.1) :
                    Color(nsColor: .separatorColor).opacity(0.1)
            )
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(
                        isSelected ? Color.accentColor.opacity(0.3) : Color.clear,
                        lineWidth: 1
                    )
            )
        }
        .buttonStyle(.plain)
    }
}
