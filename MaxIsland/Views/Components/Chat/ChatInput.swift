import SwiftUI

struct ChatInputView: View {
    @Binding var text: String
    @ObservedObject private var theme = ThemeManager.shared
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
        HStack(alignment: .bottom, spacing: 12) {
            ZStack(alignment: .leading) {
                TextEditor(text: $text)
                    .focused($isFocused)
                    .textEditorStyle(.plain)
                    .lineSpacing(2)
                    .padding(.all, 8)
                    .font(.system(size: 12))
                    .scrollContentBackground(.hidden)
                    .foregroundColor(Color.theme.text)
                    .accentColor(Color.theme.accent)
                    .frame(minHeight: 30, maxHeight: 80)
                    .fixedSize(horizontal: false, vertical: true)
                    .overlay(alignment: .leading, content: {
                        if text.isEmpty {
                            Text(placeholder)
                                .foregroundStyle(.gray)
                                .allowsHitTesting(false)
                                .padding(.leading, 12)
                        }
                    })
                    .onKeyPress{ press in
                        if press.key == .return && press.modifiers.isEmpty
                        {
                            sendMessage()
                            return .handled
                        }
                        return .ignored
                    }
            }
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.theme.background)
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
    }
    
    private func sendMessage() {
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else { return }
        
        onSend(trimmedText)
        text = ""
    }
}
