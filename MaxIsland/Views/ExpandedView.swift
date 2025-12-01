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
        }
    }
}

