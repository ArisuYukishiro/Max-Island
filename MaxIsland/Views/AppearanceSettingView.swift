import SwiftUI

struct AppearanceSettingView: View {
    @ObservedObject private var themeManager = ThemeManager.shared
    @AppStorage("AppTheme") private var appTheme: AppTheme = .systemDefault
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Theme")
                .font(.headline)
            
            Picker("Select Theme", selection: $appTheme) {
                Text("Light").tag(AppTheme.light)
                Text("Dark").tag(AppTheme.dark)
                Text("System").tag(AppTheme.systemDefault)
            }
            .pickerStyle(.segmented)
            .onChange(of: appTheme) { oldValue, newValue in
                ThemeManager.shared.set(newValue)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
