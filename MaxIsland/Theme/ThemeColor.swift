//
//  ThemeColor.swift
//  MaxIsland
//
//  Created by seang kimsinh on 5/12/25.
//

import SwiftUI

extension Color {
    static var theme: ThemeColors.Type { ThemeColors.self }
}

struct ThemeColors {
    private static var resolvedTheme: AppTheme {
            let theme = ThemeManager.shared.currentTheme
            
            // If user chooses system, detect system in real-time
            if theme == .systemDefault {
                return NSApp.effectiveAppearance.name == .darkAqua ? .dark : .light
            }
            return theme
        }
        
        static var background: Color {
            resolvedTheme == .dark ? Color.black.opacity(0.95) : Color.white.opacity(0.9)
        }
        
        static var text: Color {
            resolvedTheme == .dark ? .white : .black
        }
        
        static var accent: Color {
            resolvedTheme == .dark ? .purple : .blue
        }
        
        // Optional extra colors
        static var surface: Color {
            resolvedTheme == .dark ? Color.gray.opacity(0.25) : Color.gray.opacity(0.1)
        }}
