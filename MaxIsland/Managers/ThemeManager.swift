import SwiftUI

class ThemeManager: ObservableObject {
    static let shared = ThemeManager()
    
    @AppStorage("AppTheme") private var storedTheme: AppTheme = .systemDefault
    @Published var currentTheme: AppTheme = .systemDefault
    
    private init() {
        currentTheme = storedTheme
        applyAppearance()
    }
    
    func set(_ theme: AppTheme) {
        storedTheme = theme
        currentTheme = theme
        applyAppearance()
    }
    
    func toggle() {
        switch currentTheme {
        case .systemDefault: set(.light)
        case .light: set(.dark)
        case .dark: set(.systemDefault)
        }
    }
    
    private func applyAppearance() {
        switch currentTheme {
        case .light:
            NSApp.appearance = NSAppearance(named: .aqua)
        case .dark:
            NSApp.appearance = NSAppearance(named: .darkAqua)
        case .systemDefault:
            NSApp.appearance = nil
        }
    }
}

enum AppTheme: String, CaseIterable {
    case light, dark, systemDefault

    var colorScheme: ColorScheme? {
        switch self {
        case .light: return .light
        case .dark: return .dark
        case .systemDefault: return nil
        }
    }
}



struct ThemeSwitch<Content: View>: View {
    @ObservedObject private var theme = ThemeManager.shared
    let content: () -> Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    var body: some View {
        content()
            .preferredColorScheme(theme.currentTheme.colorScheme)
    }
}
