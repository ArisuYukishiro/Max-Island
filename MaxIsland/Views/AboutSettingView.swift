import SwiftUI


struct AboutSettingView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Max Island")
                .font(.title)
                .bold()
            
            Text("Version 1.0.0")
                .foregroundColor(.secondary)
            
            Spacer()
        }
    }
}

