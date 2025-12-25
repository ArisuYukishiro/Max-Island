import SwiftUI

struct ExpandedView: View {
    @State private var messageText = ""
    
    var body: some View {
        VStack(spacing: 0) {
            // Chat Messages
            ChatMessage()
            .navigationTitle("Chat")
            .padding([.leading, .trailing], 10)
            .padding(.bottom, 10)
            .mask(
                LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: .clear, location: 0),
                        .init(color: .black, location: 0.10),
                        .init(color: .black, location: 1)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
        }
    }
}

