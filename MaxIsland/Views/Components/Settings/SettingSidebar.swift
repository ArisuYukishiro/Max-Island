import SwiftUI


struct SettingsSidebar: View {
    @Binding var selectedSection: SettingSection
    @ObservedObject private var themeManager = ThemeManager.shared
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            // Sidebar items
            ScrollView {
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(SettingSection.allCases, id: \.self) { section in
                        SidebarItem(
                            section: section,
                            isSelected: selectedSection == section
                        ) {
                            selectedSection = section
                        }
                    }
                }
                .padding(.vertical, 8)
            }
        }
        .frame(width: 50)
        .background(themeManager.currentTheme == .dark ? Color.black.opacity(0.3) : Color.gray.opacity(0.1))
    }
}

struct SidebarItem: View {
    let section: SettingSection
    let isSelected: Bool
    let action: () -> Void
    @ObservedObject private var themeManager = ThemeManager.shared
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: section.icon)
                    .font(.system(size: 14))
                    .frame(width: 20)
                
//                Text(section.rawValue)
//                    .font(.system(size: 13))
                
//                Spacer()
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 10)
            .background(
                isSelected ?
                (themeManager.currentTheme == .dark ? Color.white.opacity(0.15) : Color.black.opacity(0.1)) :
                Color.clear
            )
            .foregroundColor(
                isSelected ?
                (themeManager.currentTheme == .dark ? .white : .black) :
                (themeManager.currentTheme == .dark ? Color.white.opacity(0.7) : Color.black.opacity(0.7))
            )
            .cornerRadius(8)
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal, 8)
    }
}
