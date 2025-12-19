import SwiftUI

// MARK: - Model

struct Shortcut: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let key: KeyEquivalent
    let modifiers: EventModifiers
}

// MARK: - Shortcut Row

struct ShortcutRow: View {
    let shortcut: Shortcut
    @State private var isHovered = false

    var body: some View {
        HStack(spacing: 12) {

            // Icon
            Image(systemName: shortcut.icon)
                .font(.system(size: 14))
                .frame(width: 30)

            // Name
            Text(shortcut.name)
                .font(.system(size: 13))

            Spacer()

            // Keybinding (macOS style)
            ShortcutKeyView(
                key: shortcut.key,
                modifiers: shortcut.modifiers
            )
            .opacity(0.55)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(isHovered ? Color.white.opacity(0.08) : Color.clear)
        .cornerRadius(6)
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.12)) {
                isHovered = hovering
            }
        }
    }
}

// MARK: - Shortcut Glyph Renderer

struct ShortcutKeyView: View {
    let key: KeyEquivalent
    let modifiers: EventModifiers

    var body: some View {
        Text(renderedShortcut)
            .font(.system(size: 16, weight: .medium, design: .monospaced))
    }

    private var renderedShortcut: String {
        var result = ""

        if modifiers.contains(.control) { result += "⌃" }
        if modifiers.contains(.option)  { result += "⌥" }
        if modifiers.contains(.shift)   { result += "⇧" }
        if modifiers.contains(.command) { result += "⌘" }

        result += keyGlyph(for: key)
        return result
    }

    private func keyGlyph(for key: KeyEquivalent) -> String {
        switch key {
        case .return:  return "⏎"
        case .escape: return "⎋"
        case .delete: return "⌫"
        case .tab:    return "⇥"
        case .space:  return "␣"
        default:
            return key.character.uppercased()
        }
    }
}


// MARK: - Main View

struct ShortCutSettingView: View {

    private let shortcuts: [Shortcut] = [
        Shortcut(
            name: "Close Notch",
            icon: "escape",
            key: .escape,
            modifiers: []
        ),
        Shortcut(
            name: "Settings",
            icon: "gearshape.fill",
            key: ",",
            modifiers: [.command, .shift]
        ),
        Shortcut(
            name: "Quit MaxIsland",
            icon: "xmark.square.fill",
            key: "q",
            modifiers: [.command]
        ),
        Shortcut(
            name: "Create New Line",
            icon: "plus.circle",
            key: .return,
            modifiers: [.option]
        )
    ]

    var body: some View {
        Text("Shortcuts").font(.title)
        VStack(alignment: .leading, spacing: 10) {

            // Header
            Text("MaxIsland Menu")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(.secondary)
                .padding(.leading, 12)
                .padding(.bottom, 8)

            // Menu body
            VStack(spacing: 1) {
                ForEach(shortcuts) { shortcut in
                    ShortcutRow(shortcut: shortcut)
                }
            }
        }
        .padding(8)
        .frame(width: 480)
        .background(Color(NSColor.windowBackgroundColor))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
        .padding()
    }
}
