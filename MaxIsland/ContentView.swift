import SwiftUI

//enum AppTheme: String, CaseIterable {
//    case light = "light"
//    case dark = "dark"
//    case systemDefault = "systemDefault"
//    
//    var colorScheme: ColorScheme? {
//        switch self {
//        case .light: return .light
//        case .dark: return .dark
//        case .systemDefault: return nil
//        }
//    }
//}
//struct ThemeSwitch<Content: View>: View {
//   @ViewBuilder var content: Content
//    @AppStorage("AppTheme") private var appTheme: AppTheme = .systemDefault
//    
//    var body: some View {
//        content
//            .preferredColorScheme(appTheme.colorScheme)
//            .id(appTheme)
//    }
//}


struct ContentView: View {
//    @AppStorage("AppTheme") private var appTheme: AppTheme = .systemDefault
    var body: some View {
        ThemeSwitch{
            VStack {
                
                Spacer()
                    .frame(height: 20)
                
                DynamicIsland()
                
            }
//            .preferredColorScheme(appTheme.colorScheme)
        }
        
    }
    
    struct DemoControls: View {
        var body: some View {
            VStack(spacing: 16) {
                Text("Tap the island to toggle states")
                    .foregroundColor(.gray)
                    .font(.system(size: 14))
                
                Text("Or use these buttons:")
                    .foregroundColor(.gray)
                    .font(.system(size: 12))
            }
            .padding()
        }
        
    }
    
    
}
