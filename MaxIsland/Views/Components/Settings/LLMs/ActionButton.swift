import SwiftUI

struct ActionButtons: View {
    var body: some View {
        HStack(spacing: 12) {
            Button("Test Connection") {
            }
            .buttonStyle(.borderedProminent)
            
            Button("Save Configuration") {
            }
            
            Spacer()
        }
    }
}
