//
//  ThemePickerView.swift
//  Max Island
//
//  Created by Sovannsak Yours on 13/3/26.
//

import SwiftUI

struct ThemePickerView: View {
    @AppStorage("AppTheme") private var appTheme: AppTheme = .systemDefault

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Theme")
                .font(.headline)

            Picker("Select Theme", selection: $appTheme) {
                Text("Light").tag(AppTheme.light)
                Text("Dark").tag(AppTheme.dark)
                Text("System").tag(AppTheme.systemDefault)
            }
            .pickerStyle(.segmented)
            .onChange(of: appTheme) { _, newValue in
                ThemeManager.shared.set(newValue)
            }
        }
    }
}
