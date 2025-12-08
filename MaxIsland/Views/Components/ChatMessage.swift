import SwiftUI

struct ChatMessage: View {
    @StateObject private var viewModel = ChatViewModel()
        
    var body: some View {
        //TODO : neeed improvement on the render first inital chat in the bottom instead of on the top, currently its work on but it rotate and scroll bar is on left side instead of the right side
        VStack(spacing: 0) {
            
            ScrollViewReader { proxy in
                ScrollView(showsIndicators: false){
                    LazyVStack(spacing: 12) {
                        // Use viewModel.messages instead of local state
                        ForEach(viewModel.messages) { message in
                            MessageBubble(message: message)
                                .id(message.id)
                        }
                        
                        // Loading indicator
                        if viewModel.isLoading {
                            HStack {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                                    .foregroundColor(.gray)
                                    .font(.caption)
                                Spacer()
                            }
                            .padding(.horizontal)
                        }
                        
                        // Error message
                        if let error = viewModel.errorMessage {
                            HStack {
                                Text("Error: \(error)")
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
                    .padding()
                    .rotationEffect(.degrees(180))
                    
                }
                .rotationEffect(.degrees(180))
                .onChange(of: viewModel.messages.count) { _,_ in
                    if let lastMessage = viewModel.messages.last {
                        withAnimation {
                            proxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
            }
            
            Divider()
            
            ChatInputView(
                    text: $viewModel.messageText,
                    placeholder: "Message"
                ) { sentText in
                    Task {await viewModel.sendMessage(text: sentText)}
                  }
            .frame(height: 45)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
    
