//
//  Theme.swift
//  MaxIsland
//
//  Created by seang kimsinh on 8/12/25.
//

import SwiftUI

extension Color {
    static var theme: ThemeColors.Type { ThemeColors.self }
}

struct ThemeColors {
    private static var currentTheme: AppTheme {
        ThemeManager.shared.currentTheme
    }
    
    static var background: Color {
        currentTheme == .dark ? Color.black.opacity(0.95) : Color.white.opacity(0.9)
    }
    
    static var text: Color {
        currentTheme == .dark ? .white : .black
    }
    
    static var accent: Color {
        currentTheme == .dark ? .purple : .blue
    }
    
    static var surface: Color {
        currentTheme == .dark ? Color.gray.opacity(0.25) : Color.gray.opacity(0.1)
    }
}
