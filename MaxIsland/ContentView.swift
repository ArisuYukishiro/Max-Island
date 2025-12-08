import SwiftUI

struct ContentView: View {
    var body: some View {
        ThemeSwitch{
            VStack {
                
                Spacer()
                    .frame(height: 20)
                
                DynamicIsland()   
            }
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
