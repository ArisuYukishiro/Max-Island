import SwiftUI

struct ChatInputView: View {
    @Binding var text: String
    var placeholder: String
    var onSend: (String) -> Void
    
    @FocusState private var isFocused: Bool
    
    init(
        text: Binding<String>,
        placeholder: String = "Message",
        onSend: @escaping (String) -> Void
    ) {
        self._text = text
        self.placeholder = placeholder
        self.onSend = onSend
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            ZStack(alignment: .leading) {
                if text.isEmpty {
                    Text(placeholder)
                        .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                        .padding(.horizontal, 12)
                }
                TextField("", text: $text, axis: .horizontal)
                    .focused($isFocused)
                    .padding(.horizontal, 12)
                    .frame(height: 30)
                    .textFieldStyle(.plain)
                    .onSubmit {
                        sendMessage()
                    }
            }
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color(red: 0.18, green: 0.18, blue: 0.18))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color(red: 0.3, green: 0.3, blue: 0.3), lineWidth: 0.5)
            )
            
            Button(action: sendMessage) {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? Color(red: 0.4, green: 0.4, blue: 0.4) : Color(red: 0.0, green: 0.48, blue: 1.0))
            }
            .disabled(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func sendMessage() {
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else { return }
        
        onSend(trimmedText)
        text = ""
    }
}
