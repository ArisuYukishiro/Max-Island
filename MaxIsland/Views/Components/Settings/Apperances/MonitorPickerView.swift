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
        VStack(alignment: .leading, spacing: 12) {
            Text("Island Monitor")
                .font(.headline)

            if screens.isEmpty {
                Text("No displays detected.")
                    .foregroundColor(.secondary)
            } else {
                VStack(spacing: 12){
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

    private var screenAspectRatio: CGFloat {
        let width = screen.frame.width
        let height = screen.frame.height
        return width / height
    }

    var body: some View {
        Button(action: onSelect) {
            VStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(nsColor: .controlBackgroundColor))
                        .aspectRatio(screenAspectRatio, contentMode: .fit)
                    
                    RoundedRectangle(cornerRadius: 6)
                        .fill(isSelected ? Color.accentColor.opacity(0.15) : Color.secondary.opacity(0.1))
                        .aspectRatio(screenAspectRatio, contentMode: .fit)
                        .padding(4)
                }
                .frame(height: 100)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(
                            isSelected ? Color.accentColor : Color.secondary.opacity(0.3),
                            lineWidth: isSelected ? 2 : 1
                        )
                )
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(screen.localizedName)
                                .font(.system(.body, design: .default))
                                .fontWeight(isSelected ? .semibold : .regular)
                            
                            Text("\(Int(screen.frame.width)) × \(Int(screen.frame.height))")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(12)
            .background(Color(nsColor: .controlBackgroundColor).opacity(0.5))
            .cornerRadius(10)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

extension Notification.Name {
    static let preferredMonitorDidChange = Notification.Name("preferredMonitorDidChange")
}
