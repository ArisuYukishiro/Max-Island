import SwiftUI

struct AppearanceSettingView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            ThemePickerView()
            MonitorPickerView()
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
