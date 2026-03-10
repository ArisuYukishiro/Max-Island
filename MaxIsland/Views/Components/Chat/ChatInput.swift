import SwiftUI
import AppKit

final class EventMonitorToken {
    private let token: Any
    init(_ token: Any) { self.token = token }
    deinit { NSEvent.removeMonitor(token) }
}

struct ChatInputView: View {
    @Binding var text: String
    @ObservedObject private var theme = ThemeManager.shared
    var placeholder: String
    var onSend: (String) -> Void

    @FocusState private var isFocused: Bool
    @State private var keyMonitor: EventMonitorToken?

    init(
        text: Binding<String>,
        placeholder: String = "Message",
        onSend: @escaping (String) -> Void
    ) {
        self._text = text
        self.placeholder = placeholder
        self.onSend = onSend
    }

    private var canSend: Bool {
        !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
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

                if text.isEmpty && !isFocused {
                    Text(placeholder)
                        .foregroundStyle(.gray)
                        .font(.system(size: 12))
                        .allowsHitTesting(false)
                        .padding(.leading, 12)
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
            .onAppear {
                //  From Apple's official documentation, NSEvent.addLocalMonitorForEvents return Any?
                guard let token = NSEvent.addLocalMonitorForEvents(matching: .keyDown, handler: { event in
                    let chars = event.characters ?? ""
                    let isReturn = event.keyCode == 36 //.return key
                    let noModifiers = event.modifierFlags.intersection([.shift, .option, .command]).isEmpty

                    if isFocused {
                        let isComposing = (NSApp.keyWindow?.firstResponder as? NSTextView)?.hasMarkedText() ?? false
                     // print("[ChatInput] key=\(event.keyCode) chars='\(chars)' isReturn=\(isReturn) isComposing=\(isComposing) focused=\(isFocused)")
                    }

                    guard isReturn, noModifiers else { return event }

                    // IME is composing — let it confirm the character
                    if let tv = NSApp.keyWindow?.firstResponder as? NSTextView, tv.hasMarkedText() {
                        print("[ChatInput] Return consumed by IME — committing composition")
                        return event
                    }

                    if isFocused {
                        print("[ChatInput] Return → sending message")
                        sendMessage()
                        return nil
                    }
                    return event
                }) else { return }
                keyMonitor = EventMonitorToken(token)
            }
            .onDisappear {
                keyMonitor = nil
            }

            Button(action: sendMessage) {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(canSend ? Color(red: 0.0, green: 0.48, blue: 1.0) : Color(red: 0.4, green: 0.4, blue: 0.4))
            }
            .disabled(!canSend)
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }

    private func sendMessage() {
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else { return }
        onSend(trimmedText)
    }
}


