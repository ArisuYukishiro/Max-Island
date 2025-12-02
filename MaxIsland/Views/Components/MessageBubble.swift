import SwiftUI
import MarkdownUI

struct MessageBubble: View {
    let message: Message
    
    var body: some View {
        HStack {
            if message.isUser { Spacer() }
            Markdown {message.text}
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(
                    message.isUser
                        ? Color.blue
                        : Color.gray.opacity(0.2)
                )
                .foregroundColor(message.isUser ? .white : .primary)
                .cornerRadius(18)
            
            if !message.isUser { Spacer() }
        }
    }
}


