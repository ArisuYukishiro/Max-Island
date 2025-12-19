import SwiftUI


enum SettingSection: String, CaseIterable {
    case appearance = "Appearance"
    case general = "General"
    case llmConfig = "LLM Config"
    case notifications = "Notifications"
    case advanced = "Advanced"
    case about = "About"
    
    var icon: String {
        switch self {
        case .appearance:
            return "paintbrush.fill"
        case .general:
            return "gearshape.fill"
        case .llmConfig:
            return "brain.fill"
        case .notifications:
            return "bell.fill"
        case .advanced:
            return "slider.horizontal.3"
        case .about:
            return "info.circle.fill"
        }
    }
}

struct SettingView: View {
    @Binding var isPresented: Bool
    @State private var selectedSection: SettingSection = .appearance
    @State private var columnVisibility: NavigationSplitViewVisibility = .all
    @ObservedObject private var themeManager = ThemeManager.shared
    
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility){
            SettingsSidebar(selectedSection: $selectedSection, columnVisibility: $columnVisibility)
                .navigationSplitViewColumnWidth(min: 200, ideal: 200, max: 200)
            //NOTE : find way to remove sidebar toggle without moving sidebar outside of control window
            //toolbar(removing: .sidebarToggle)
        }
        detail: {
            VStack(spacing: 0) {
                contentView
                        .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(themeManager.currentTheme == .dark ? Color.black : Color.white)
        }.navigationSplitViewStyle(.balanced)
    }
    
    @ViewBuilder
    private var contentView: some View {
        switch selectedSection {
        case .appearance:
            AppearanceSettingView()
        case .general:
            GeneralSettingView()
        case .llmConfig:
            LLMConfigSettingView()
        case .notifications:
            NotificationsSettingView()
        case .advanced:
            AdvancedSettingView()
        case .about:
            AboutSettingView()
        }
    }
}
