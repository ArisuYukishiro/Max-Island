import Foundation
import SwiftUI

@MainActor
class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var messageText = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let llmConfigManager: LLMConfigManager
    private var apiService: ChatAPIService
    private let storageManager = ChatStorageManager.shared
    
    init(llmConfigManager: LLMConfigManager) {
        self.llmConfigManager = llmConfigManager
        self.apiService = ChatAPIService(llmConfigManager: llmConfigManager)
        loadMessages()
    }
    
    func loadMessages() {
        messages = storageManager.loadMessages()
    }
    
    func sendMessage(text: String) async {
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else { return }
        
        guard !llmConfigManager.currentAPIKey.isEmpty else {
            errorMessage = "Please configure an API key for \(llmConfigManager.selectedProvider.rawValue) in Settings"
            let errorMsg = Message(
                text: "⚠️ API key not configured. Please add your API key in Settings.",
                isUser: false
            )
            messages.append(errorMsg)
            return
        }
        
        let userMessage = Message(text: trimmedText, isUser: true)
        messages.append(userMessage)
        saveMessages()
        
        messageText = ""
        errorMessage = nil
        isLoading = true
        
        #if DEBUG
        print("🚀 Sending message with:")
        print("   Provider: \(llmConfigManager.selectedProvider.rawValue)")
        print("   Model: \(llmConfigManager.selectedModel)")
        print("   API Key: [\(llmConfigManager.currentAPIKey.prefix(10))...]")
        #endif
        
        do {
            let responseText = try await apiService.sendMessage(trimmedText)
            
            let botMessage = Message(text: responseText, isUser: false)
            messages.append(botMessage)
            saveMessages()
            
        } catch let error as APIError {
            handleError(error)
        } catch {
            handleError(.serverError(error.localizedDescription))
        }
        
        isLoading = false
    }
    
    private func saveMessages() {
        storageManager.saveMessages(messages)
    }
    
    func clearChat() {
        messages = [Message(text: "Hello! How can I help you?", isUser: false)]
        storageManager.clearMessages()
    }
    
    private func handleError(_ error: APIError) {
        switch error {
        case .invalidURL:
            errorMessage = "Invalid API URL"
        case .invalidResponse:
            errorMessage = "Invalid server response"
        case .decodingError:
            errorMessage = "Failed to decode response"
        case .serverError(let message):
            errorMessage = "Server error: \(message)"
        case .missingAPIKey:
            errorMessage = "API key not configured for \(llmConfigManager.selectedProvider.rawValue)"
        }
        
        let errorMsg = Message(
            text: "Sorry, I couldn't process your message. \(errorMessage ?? "Please try again.")",
            isUser: false
        )
        messages.append(errorMsg)
        saveMessages()
    }
    
    var canSend: Bool {
        !messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        && !isLoading
        && !llmConfigManager.currentAPIKey.isEmpty
    }
    
    var currentProviderInfo: String {
        "\(llmConfigManager.selectedProvider.rawValue) - \(llmConfigManager.selectedModel)"
    }
}
