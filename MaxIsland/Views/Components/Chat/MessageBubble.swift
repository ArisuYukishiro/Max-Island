import SwiftUI
import MarkdownUI
import Splash


struct MessageBubble: View {
    @State private var showCopied = false
    @State private var copiedBlocks: [Int: Bool] = [:]
    @State private var isHovering = false
    @ObservedObject private var themeManager = ThemeManager.shared
    @SwiftUI.Environment(\.colorScheme) private var colorScheme
    
    let message: Message
  
    var body: some View {
        HStack {
            if message.isUser { Spacer() }
    
            HStack(spacing: 4) {
                Markdown(message.text)
                    .markdownBlockStyle(\.codeBlock) {
                      codeBlock($0)
                    }
                    .markdownCodeSyntaxHighlighter(.splash(theme: self.theme))
                    .foregroundColor(message.isUser ? .white : getAssistantTextColor())
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .textSelection(.enabled)
                    .overlay(alignment: .topTrailing) {
                        if message.text.count > 75 && !message.text.trimmingCharacters(in: .whitespacesAndNewlines).hasPrefix("```") {
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
    
    private func getAssistantBackgroundColorForUser() -> SwiftUI.Color {
        themeManager.currentTheme == .dark ? .blue : Color.gray.opacity(0.3)
    }
    
    //Note: the reason color opacity 0.001 is the make background unseenable but still able to hover on bakground
    private func getAssistantBackgroundColorForBot() -> SwiftUI.Color {
        themeManager.currentTheme == .dark
            ? Color.gray.opacity(0.001)
            : Color.gray.opacity(0.001)
    }

    private func getAssistantTextColor() -> SwiftUI.Color {
        themeManager.currentTheme == .dark ? .white : .black
    }
    
    
    private var codeBlockHeaderBackground: SwiftUI.Color {
        colorScheme == .dark ? SwiftUI.Color(theme.backgroundColor) : Color.gray.opacity(0.2)
    }

    private var codeBlockBackground: SwiftUI.Color {
        colorScheme == .dark ? SwiftUI.Color(theme.backgroundColor) : Color.gray.opacity(0.1)
    }
    
    @ViewBuilder
      private func codeBlock(_ configuration: CodeBlockConfiguration) -> some View {
        VStack(spacing: 0) {
          HStack {
            Text(configuration.language ?? "plain text")
              .font(.system(.caption, design: .monospaced))
              .fontWeight(.semibold)
              .foregroundColor(Color(theme.plainTextColor))
            Spacer()
              
              Button(action: {
                  copyToClipboard(configuration.content)
                  let blockId = configuration.content.hashValue
                  copiedBlocks[blockId] = true
                  DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                      copiedBlocks[blockId] = nil
                  }
              }) {
                  Image(systemName: (copiedBlocks[configuration.content.hashValue] == true) ? "checkmark" : "doc.on.doc")
                      .font(.system(size: 12))
                      .foregroundColor(SwiftUI.Color(theme.plainTextColor))
                      .animation(.easeInOut(duration: 0.2), value: copiedBlocks[configuration.content.hashValue] == true)
              }
              .buttonStyle(.plain)
          }
          .padding(.horizontal)
          .padding(.vertical, 8)
          .background {
              codeBlockHeaderBackground
          }
          Divider()

          ScrollView(.horizontal) {
            configuration.label
              .relativeLineSpacing(.em(0.25))
              .markdownTextStyle {
                FontFamilyVariant(.monospaced)
                FontSize(.em(0.85))
              }
              .padding()
          }
        }
        .background(codeBlockBackground)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .markdownMargin(top: .zero, bottom: .em(0.8))
      }
    
    private var theme: Splash.Theme {
      switch self.colorScheme {
      case .dark:
        return .wwdc17(withFont: .init(size: 16))
      default:
        return .sunset(withFont: .init(size: 16))
      }
    }
    
    private func copyToClipboard(_ string: String) {
          #if os(macOS)
          let pasteboard = NSPasteboard.general
          pasteboard.clearContents()
          pasteboard.setString(string, forType: .string)
          #elseif os(iOS)
          UIPasteboard.general.string = string
          #endif
      }
}
