import SwiftUI

struct ChatMessage: View {
    @State private var messageText = ""
    @State private var messages: [Message] = [
        Message(text: "Hello! How can I help you?", isUser: false),
    ]
    
    var body: some View {
        //TODO : neeed improvement on the render first inital chat in the bottom instead of on the top, currently its work on but it rotate and scroll bar is on left side instead of the right side
        VStack(spacing: 0) {
            ScrollViewReader { proxy in
                ScrollView(showsIndicators: false){
                        LazyVStack(spacing: 12) {
                            ForEach(messages) { message in
                                MessageBubble(message: message)
                                    .id(message.id)
                            }
                        }
                        .padding()
                        .rotationEffect(.degrees(180))

                }
                .rotationEffect(.degrees(180))
                .onChange(of: messages.count) { _,_ in
                    if let lastMessage = messages.last {
                        withAnimation {
                            proxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
            }
            
            Divider()
            
            // Chat Input Component with Props
            ChatInputView(
                text: $messageText,
                placeholder: "Message"
            ) { sentText in
                handleSendMessage(sentText)
            }
            .frame(height: 45)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)

    }
    
    private func handleSendMessage(_ text: String) {
        let newMessage = Message(text: text, isUser: true)
        messages.append(newMessage)
        
        // Simulate response
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let response = Message(text: "I received: \"\(text)\"", isUser: false)
            messages.append(response)
        }
    }
}

struct Message: Identifiable {
    let id = UUID()
    let text: String
    let isUser: Bool
}

struct MessageBubble: View {
    let message: Message
    
    var body: some View {
        HStack {
            if message.isUser { Spacer() }
            
            Text(message.text)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(
                    message.isUser
                        ? Color.blue
                    : Color.gray
                )
                .foregroundColor(message.isUser ? .white : .primary)
                .cornerRadius(18)
            
            if !message.isUser { Spacer() }
        }
    }
}
