import SwiftUI

struct ErrorView: View {
    let message: String
    
    var body: some View {
        HStack {
            Text("Error: \(message)")
                .foregroundColor(.red)
                .font(.caption)
                .padding()
                .background(Color.red.opacity(0.1))
                .cornerRadius(8)
            Spacer()
        }
        .padding(.horizontal)
    }
}
