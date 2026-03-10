import SwiftUI

struct SkeletonChatInput: View {
    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.2))
                .frame(height: 36)
            
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.2))
                .frame(width: 36, height: 36)
        }
        .padding(.horizontal, 12)
    }
}
