import SwiftUI

struct CompactView: View {
    var body: some View {
        HStack(spacing: 6) {}
        .transition(.scale.combined(with: .opacity))
    }
}
