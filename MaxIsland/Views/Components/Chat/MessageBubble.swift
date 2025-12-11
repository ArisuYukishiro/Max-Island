import SwiftUI
import MarkdownUI

struct MessageBubble: View {
    @State private var showCopied = false
    @State private var isHovering = false
    @ObservedObject private var themeManager = ThemeManager.shared

    let message: Message
    
    var body: some View {
        HStack {
            if message.isUser { Spacer() }
    
            HStack(spacing: 4) {
                Markdown {message.text}
                    .markdownTheme(.basic)
                    .foregroundColor(message.isUser ? .white : getAssistantTextColor())
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .textSelection(.enabled)
                    .overlay(alignment: .topTrailing) {
                        if message.text.count > 75 {
                            Button(action: {
                                let pasteboard = NSPasteboard.general
                                pasteboard.clearContents()
                                pasteboard.setString(message.text, forType: .string)
                                
                                showCopied = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    showCopied = false
                                }
                            }) {
                                Image(systemName: showCopied ? "checkmark" : "doc.on.doc")
                                    .font(.system(size: 10))
                                    .foregroundColor(message.isUser ? .white.opacity(0.7) : .gray)
                                    .padding(4)
                                    .background(
                                        RoundedRectangle(cornerRadius: 6)
                                            .fill(.ultraThinMaterial)
                                            .background(
                                                RoundedRectangle(cornerRadius: 6)
                                                    .stroke(Color.white.opacity(0.2))
                                            )
                                    )
                            }
                            .padding(.vertical, 6)
                            .padding(.horizontal, 8)
                            .buttonStyle(.plain)
                            .opacity((isHovering || showCopied) ? 1 : 0)
                        }
                    }
            }
            .background(
                message.isUser ? getAssistantBackgroundColorForUser() : getAssistantBackgroundColorForBot()
            )
            .cornerRadius(18)
            .onHover { hovering in isHovering = hovering }
            
            if !message.isUser { Spacer() }
        }
    }
    
    private func getAssistantBackgroundColorForUser() -> Color {
        themeManager.currentTheme == .dark ? .blue : Color.gray.opacity(0.3)
    }
    
    //Note: the reason color opacity 0.001 is the make background unseenable but still able to hover on bakground
    private func getAssistantBackgroundColorForBot() -> Color {
        themeManager.currentTheme == .dark
            ? Color.gray.opacity(0.001)
            : Color.gray.opacity(0.001)
    }

    private func getAssistantTextColor() -> Color {
        themeManager.currentTheme == .dark ? .white : .black
    }
}
