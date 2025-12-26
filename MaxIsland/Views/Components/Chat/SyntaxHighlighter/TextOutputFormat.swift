import Splash
import SwiftUI

extension SwiftUI.Color {
  #if os(macOS)
  init(platformColor: NSColor) {
    self.init(nsColor: platformColor)
  }
  #else
  init(platformColor: UIColor) {
    self.init(uiColor: platformColor)
  }
  #endif
}

struct TextOutputFormat: OutputFormat {
  private let theme: Theme

  init(theme: Theme) {
    self.theme = theme
  }

  func makeBuilder() -> Builder {
    Builder(theme: self.theme)
  }
}

extension TextOutputFormat {
  struct Builder: OutputBuilder {
    private let theme: Theme
    private var attributedString: AttributedString

    fileprivate init(theme: Theme) {
      self.theme = theme
      self.attributedString = AttributedString()
    }

    mutating func addToken(_ token: String, ofType type: TokenType) {
      let color = self.theme.tokenColors[type] ?? self.theme.plainTextColor
      var attributed = AttributedString(token)
      attributed.foregroundColor = .init(platformColor: color)
      self.attributedString.append(attributed)
    }

    mutating func addPlainText(_ text: String) {
      var attributed = AttributedString(text)
      attributed.foregroundColor = .init(platformColor: self.theme.plainTextColor)
      self.attributedString.append(attributed)
    }

    mutating func addWhitespace(_ whitespace: String) {
      self.attributedString.append(AttributedString(whitespace))
    }

    func build() -> Text {
      Text(self.attributedString)
    }
  }
}
