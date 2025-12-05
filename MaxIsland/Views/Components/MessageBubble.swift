import SwiftUI
import MarkdownUI
extension Color {
    init(r: Double, g: Double, b: Double, opacity: Double = 1.0) {
        self.init(red: r/255, green: g/255, blue: b/255, opacity: opacity)
    }
}
struct MessageBubble: View {
    @State private var showCopied = false
    @State private var isHovering = false
    let message: Message
    
    var body: some View {
        HStack {
            if message.isUser { Spacer() }
    
            HStack(spacing : 4) {
                Markdown {message.text}
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .textSelection(.enabled)
                
                    .overlay(alignment: .topTrailing) {
                        // neeed improve how to display button if text more than one line
                        if message.text.count > 75  {
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
            .background(message.isUser ? Color(r: 0, g: 191, b: 225): Color.gray.opacity(0.2))
            .foregroundColor(message.isUser ? .white : .primary)
            .cornerRadius(18)
            .onHover { hovering in isHovering = hovering }
            
            if !message.isUser { Spacer() }
        }
    }
}
