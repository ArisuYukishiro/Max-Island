import SwiftUI


enum SettingSection: String, CaseIterable {
    case appearance = "Appearance"
    case general = "General"
    case notifications = "Notifications"
    case advanced = "Advanced"
    case about = "About"
    
    var icon: String {
        switch self {
        case .appearance:
            return "paintbrush.fill"
        case .general:
            return "gearshape.fill"
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
    @ObservedObject private var themeManager = ThemeManager.shared
    
    var body: some View {
        HStack(spacing: 0) {
            SettingsSidebar(selectedSection: $selectedSection)
            
            Divider()
                .background(themeManager.currentTheme == .dark ? Color.white.opacity(0.2) : Color.black.opacity(0.2))
            
            VStack {
                HStack {
                    Text(selectedSection.rawValue)
                        .font(.title2)
                        .bold()
                    
                    Spacer()
                }
                .padding()
                
                Divider()
                
                ScrollView {
                    contentView
                        .padding()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(themeManager.currentTheme == .dark ? Color.black : Color.white)
    }
    
    @ViewBuilder
    private var contentView: some View {
        switch selectedSection {
        case .appearance:
            AppearanceSettingView()
        case .general:
            GeneralSettingView()
        case .notifications:
            NotificationsSettingView()
        case .advanced:
            AdvancedSettingView()
        case .about:
            AboutSettingView()
        }
    }
}
