import SwiftUI
import AppKit

class NotchWindowController: NSWindowController {
    @ObservedObject private var stateManager = IslandStateManager.shared

    private static func calculateNotchSize(for screenWidth: CGFloat) -> (width: CGFloat, height: CGFloat) {
        if screenWidth >= 2560 {
            return (350, 42)
        } else if screenWidth >= 1800 {
            return (300, 38)
        } else if screenWidth >= 1400 {
            return (250, 32)
        } else {
            return (max(screenWidth * 0.15, 150), 32)
        }
    }
    //TODO : fix the carry state of  handscreenchange size of notch when switch from one monitor to another with different resolution, maybe need to listen for screen change and update the notch size accordingly
    convenience init() {
        // guard let screen = NSScreen.main else {
        //     self.init(window: nil)
        //     return
        // }dyan

        let storedID = UserDefaults.standard.integer(forKey: "PreferredMonitorID")

        let screen: NSScreen
        if storedID != 0,
        let preferred = NSScreen.screens.first(where: {
            let id = $0.deviceDescription[NSDeviceDescriptionKey("NSScreenNumber")] as? CGDirectDisplayID
            return Int(id ?? 0) == storedID
        }) {
            screen = preferred
        } else if let main = NSScreen.main {
            screen = main
        } else {
            self.init(window: nil)
            return
        }
        
        let screenFrame = screen.frame
        let size = NotchWindowController.calculateNotchSize(for: screen.visibleFrame.width)
        
        let windowRect = NSRect(
            x: screenFrame.origin.x + (screenFrame.width - size.width) / 2,
            y: screenFrame.maxY - size.height,
            width: size.width,
            height: size.height
        )
        
        let window = NotchWindow(
            contentRect: windowRect,
            styleMask: [.borderless, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        
        window.isOpaque = false
        window.backgroundColor = .clear
        window.level = .statusBar
        window.collectionBehavior = [.canJoinAllSpaces, .stationary, .ignoresCycle]
        window.hasShadow = false
        
        let contentView = NSHostingView(rootView: DynamicIsland())
        contentView.autoresizingMask = [.width, .height]
        window.contentView = contentView
        
        self.init(window: window)
        
        // Listen for resolution changes
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleScreenChange),
            name: NSApplication.didChangeScreenParametersNotification,
            object: nil
        )
        // listen for preferred monitor changes
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handlePreferredMonitorChange(_:)),
            name: .preferredMonitorDidChange,
            object: nil
        )
    }
    
    @objc func handleScreenChange(notification: Notification) {
        guard let window = self.window,
              let screen = window.screen ?? NSScreen.main else { return }
        
        let screenFrame = screen.frame
        let size = NotchWindowController.calculateNotchSize(for: screen.visibleFrame.width)
        
        let newOrigin = NSPoint(
            x: screenFrame.origin.x + (screenFrame.width - size.width) / 2,
            y: screenFrame.maxY - size.height
        )
        
        window.setFrame(
            NSRect(origin: newOrigin, size: CGSize(width: size.width, height: size.height)),
            display: true,
            animate: true
        )

        NotificationCenter.default.post(name: NSNotification.Name("MonitorDidChange"), object: nil)
    }

    @objc func handlePreferredMonitorChange(_ notification: Notification) {
        guard let displayID = notification.userInfo?["displayID"] as? Int else { return }
        let targetScreen = NSScreen.screens.first {
            let id = $0.deviceDescription[NSDeviceDescriptionKey("NSScreenNumber")] as? CGDirectDisplayID
            return Int(id ?? 0) == displayID
        } ?? NSScreen.main

        guard let screen = targetScreen, let window = self.window else { return }
        let size = NotchWindowController.calculateNotchSize(for: screen.visibleFrame.width)
        let newFrame = NSRect(
            x: screen.frame.origin.x + (screen.frame.width - size.width) / 2,
            y: screen.frame.maxY - size.height,
            width: size.width,
            height: size.height
        )
        window.setFrame(newFrame, display: true, animate: true)
    }
}

class NotchWindow: NSWindow {
    override var canBecomeKey: Bool { true }
    override var canBecomeMain: Bool { false }
    
    // Allow clicks to pass through transparent areas
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
    }
}
