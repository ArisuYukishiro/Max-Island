//
//  MonitorPickerView.swift
//  Max Island
//
//  Created by Sovannsak Yours on 13/3/26.
//

import SwiftUI
import AppKit

struct MonitorPickerView: View {
    @AppStorage("PreferredMonitorID") private var preferredMonitorID: Int = 0

    @State private var screens: [NSScreen] = NSScreen.screens

    private var selectedScreen: NSScreen? {
        screens.first { displayID(for: $0) == preferredMonitorID } ?? NSScreen.main
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Island Monitor")
                .font(.headline)

            if screens.isEmpty {
                Text("No displays detected.")
                    .foregroundColor(.secondary)
            } else {
                ForEach(screens, id: \.self) { screen in
                    MonitorRowView(
                        screen: screen,
                        isSelected: displayID(for: screen) == (preferredMonitorID == 0 ? displayID(for: NSScreen.main) : preferredMonitorID),
                        isMain: screen == NSScreen.main
                    ) {
                        let id = displayID(for: screen)
                        preferredMonitorID = id
                        NotificationCenter.default.post(
                            name: .preferredMonitorDidChange,
                            object: nil,
                            userInfo: ["displayID": id]
                        )
                    }
                }
            }
        }
        .onReceive(
            NotificationCenter.default.publisher(for: NSApplication.didChangeScreenParametersNotification)
        ) { _ in
            screens = NSScreen.screens
        }
    }

    private func displayID(for screen: NSScreen?) -> Int {
        guard let screen else { return 0 }
        let id = screen.deviceDescription[NSDeviceDescriptionKey("NSScreenNumber")] as? CGDirectDisplayID
        return Int(id ?? 0)
    }
}

private struct MonitorRowView: View {
    let screen: NSScreen
    let isSelected: Bool
    let isMain: Bool
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 12) {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isSelected ? .accentColor : .secondary)

                VStack(alignment: .leading, spacing: 2) {
                    Text(screen.localizedName)
                        .fontWeight(isSelected ? .semibold : .regular)
                    if isMain {
                        Text("Main Display")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Text("\(Int(screen.frame.width)) × \(Int(screen.frame.height))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .padding(.vertical, 4)
    }
}

extension Notification.Name {
    static let preferredMonitorDidChange = Notification.Name("preferredMonitorDidChange")
}
