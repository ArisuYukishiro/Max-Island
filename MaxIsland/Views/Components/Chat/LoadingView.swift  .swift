import SwiftUI

struct LoadingView: View {
    var body: some View {
        HStack {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
            Text("Typing...")
                .foregroundColor(.gray)
                .font(.caption)
            Spacer()
        }
        .padding(.horizontal)
    }
}
