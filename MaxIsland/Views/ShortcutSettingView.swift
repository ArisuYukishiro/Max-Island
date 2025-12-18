import SwiftUI

struct Shortcut: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var icon: String
    var keybinding: String
}

struct ShortcutRow: View {
    let shortcut: Shortcut
    @State private var isHovered = false
    
    var body: some View {
        HStack(spacing: 12) {
            // Icon handling (handles cases where icon might not be an SF Symbol)
            Group {
                if shortcut.icon == "Esc" {
                    Text("⎋").font(.system(size: 14))
                } else {
                    Image(systemName: shortcut.icon)
                }
            }
            .frame(width: 30, alignment: .center)
            
            Text(shortcut.name)
                .font(.system(size: 13))
            
            Spacer()
            
            // Keybinding styled like macOS shortcuts
            Text(shortcut.keybinding)
                .font(.system(size: 11))
                .opacity(0.5)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        // This creates the "Selection" effect from your image
        .background(isHovered ? Color.white.opacity(0.1) : Color.clear)
        .cornerRadius(6)
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.1)) {
                isHovered = hovering
            }
        }
    }
}

struct ShortCutSettingView: View {
    @State private var shortcuts: [Shortcut] = [
        Shortcut(name: "Close Notch", icon: "escape", keybinding: "⎋"),
        Shortcut(name: "Settings", icon: "gearshape.fill", keybinding: "⌘ ⇧ ,"),
        Shortcut(name: "Quit MaxIsland", icon: "xmark.square.fill", keybinding: "⌘ Q")
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 10, ) {
            // Header
            Text("MaxIsland Menu")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(.secondary)
                .padding(.leading, 12)
                .padding(.bottom, 8)

            // The Menu Body (Using ScrollView for safety, or VStack for fixed size)
            VStack(spacing: 1) {
                ForEach(shortcuts) { shortcut in
                    ShortcutRow(shortcut: shortcut)
                    
                    // Logic to add a divider after specific items if needed
                    if shortcut.name == "Settings" {
                        Divider()
                            .padding(.vertical, 4)
                            .padding(.horizontal, 8)
                    }
                }
            }
        }
        .padding(8)
        .frame(width: 480)
        .background(Color(NSColor.windowBackgroundColor)) // Native Mac dark/light feel
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
        .padding()
    }
}
