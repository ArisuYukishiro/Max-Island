import Foundation
import SwiftUI

@MainActor
class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var messageText = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let apiService = ChatAPIService()
    
    private let storageManager = ChatStorageManager.shared
      
      init() {
          loadMessages()
      }
      
      func loadMessages() {
          messages = storageManager.loadMessages()
      }
    
    func sendMessage(text : String) async {
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else { return }
        
        let userMessage = Message(text: trimmedText, isUser: true)
        messages.append(userMessage)
        saveMessages()
        
        messageText = ""
        errorMessage = nil
        isLoading = true
        
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
        }
        
        let errorMsg = Message(
            text: "Sorry, I couldn't process your message. Please try again.",
            isUser: false
        )
        messages.append(errorMsg)
    }
    
    var canSend: Bool {
        !messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !isLoading
    }
}
