import SwiftUI

struct SettingView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Settings")
                    .font(.title2)
                    .bold()
                
                Spacer()
                
                Button("Done") {
                    isPresented = false
                }
            }
            .padding()
            
            Spacer()
            
            Text("Settings coming soon...")
                .foregroundColor(.secondary)
            
            Spacer()
        }
        .frame(minWidth: 600, minHeight: 400)
    }
}
