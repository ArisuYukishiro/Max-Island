import SwiftUI
import Combine

class ThemeManager: ObservableObject {
    static let shared = ThemeManager()
    
    @AppStorage("AppTheme") private var storedTheme: AppTheme = .systemDefault
    @Published var currentTheme: AppTheme = .systemDefault
    
    private var cancellables = Set<AnyCancellable>()
    private var appearanceObservation: NSKeyValueObservation?
    
    private init() {
        // Initialize current theme
        updateCurrentTheme()
        applyAppearance()
        
        appearanceObservation = NSApp.observe(\.effectiveAppearance, options: [.new]) { [weak self] _, _ in
            DispatchQueue.main.async {
                self?.systemThemeChanged()
            }
        }
    }
    
    @objc private func systemThemeChanged() {
        guard storedTheme == .systemDefault else { return }
        
        let newTheme = checkSystemAppearance()
        if newTheme != currentTheme {
            currentTheme = newTheme
            applyAppearance()
            print("🌓 System theme changed to: \(currentTheme.displayName)")
        }
    }
    
    private func updateCurrentTheme() {
        if storedTheme == .systemDefault {
            currentTheme = checkSystemAppearance()
            print("🌓 System initialized, resolve to: \(currentTheme.displayName)")
        } else {
            currentTheme = storedTheme
        }
    }
    
    private func checkSystemAppearance() -> AppTheme {
        let appearance = NSApp.effectiveAppearance
        let aquaAppearance = appearance.bestMatch(from: [.darkAqua, .aqua])
        return aquaAppearance == .darkAqua ? .dark : .light
    }
    
    func set(_ theme: AppTheme) {
        storedTheme = theme
        updateCurrentTheme()
        applyAppearance()
        
        if theme == .systemDefault {
            print("🌓 Set to system default, resolved to: \(currentTheme.displayName)")
        }
    }
    
    func toggle() {
        switch storedTheme {
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
            // This shouldn't happen since we resolve it, but just in case
            NSApp.appearance = nil
        }
    }
    
    deinit {
        DistributedNotificationCenter.default.removeObserver(self)
        appearanceObservation?.invalidate()
        cancellables.removeAll()
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
    
    var displayName: String {
        switch self {
        case .light: return "Light"
        case .dark: return "Dark"
        case .systemDefault: return "System"
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
