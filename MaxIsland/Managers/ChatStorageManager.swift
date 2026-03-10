import SwiftUI


class ChatStorageManager {
    static let shared = ChatStorageManager()
    private let messagesKey = "savedChatMessages"
    
    func saveMessages(_ messages: [Message]) {
        if let encoded = try? JSONEncoder().encode(messages) {
            UserDefaults.standard.set(encoded, forKey: messagesKey)
        }
    }
    
    func loadMessages() -> [Message] {
        guard let data = UserDefaults.standard.data(forKey: messagesKey),
              let messages = try? JSONDecoder().decode([Message].self, from: data) else {
            return [Message(text: "Hello! How can I help you?", isUser: false)]
        }
        return messages
    }
    
    func clearMessages() {
        UserDefaults.standard.removeObject(forKey: messagesKey)
    }
}
