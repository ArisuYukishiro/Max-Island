import SwiftUI

struct SkeletonMessageBubble: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 200, height: 12)
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 150, height: 12)
            }
            .padding(12)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
            
            Spacer()
        }
    }
}

