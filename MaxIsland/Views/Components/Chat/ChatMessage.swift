import SwiftUI

struct ChatMessage: View {
    @StateObject private var llmConfigManager = LLMConfigManager.shared
    @StateObject private var viewModel = ChatViewModel(llmConfigManager: .shared)
    @ObservedObject private var stateManager = IslandStateManager.shared
    @ObservedObject private var islandAnimation = IslandAnimationManager.shared

    
    var body: some View {
        if stateManager.islandState == .expanded {
            if islandAnimation.hasAnimationCompleted == true {
                skeletonContent
            } else {
                chatContent
            }
        } else {
            EmptyView()
        }
    }
    
    private var skeletonContent: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 12) {
                    ForEach(0..<3, id: \.self) { _ in
                        SkeletonMessageBubble()
                    }
                }
                .padding()
            }
            
            Divider()
            
            SkeletonChatInput()
                .frame(height: 45)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var chatContent: some View {
        VStack(spacing: 0) {
            ScrollViewReader { proxy in
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 12) {
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
                .onChange(of: viewModel.messages.count) { _, _ in
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
                placeholder: "Message (\(llmConfigManager.selectedModel))"
            ) { sentText in
                Task { await viewModel.sendMessage(text: sentText) }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .transition(.opacity)
        .onAppear {
            llmConfigManager.loadConfigLLM()
        }
    }
}
