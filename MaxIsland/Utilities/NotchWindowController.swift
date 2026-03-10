import SwiftUI
import AppKit

class NotchWindowController: NSWindowController {
    
    // 1. Centralized logic for sizing so it's consistent everywhere
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

    convenience init() {
        guard let screen = NSScreen.main else {
            self.init(window: nil)
            return
        }
        
        // Initial Calculation
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
        
        // Window Setup
        window.isOpaque = false
        window.backgroundColor = .clear
        window.level = .statusBar
        window.collectionBehavior = [.canJoinAllSpaces, .stationary, .ignoresCycle]
        window.hasShadow = false
        
        let contentView = NSHostingView(rootView: DynamicIsland())
        contentView.autoresizingMask = [.width, .height]
        window.contentView = contentView
        
        self.init(window: window)
        
        // Listen for resolution/display changes
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleScreenChange),
            name: NSApplication.didChangeScreenParametersNotification,
            object: nil
        )
    }
    
    @objc func handleScreenChange(notification: Notification) {
        // Use window.screen if available, otherwise main screen
        guard let window = self.window,
              let screen = window.screen ?? NSScreen.main else { return }
        
        let screenFrame = screen.frame
        let size = NotchWindowController.calculateNotchSize(for: screen.visibleFrame.width)
        
        let newOrigin = NSPoint(
            x: screenFrame.origin.x + (screenFrame.width - size.width) / 2,
            y: screenFrame.maxY - size.height
        )
        
        // Animate the transition to the new resolution layout
        window.setFrame(
            NSRect(origin: newOrigin, size: CGSize(width: size.width, height: size.height)),
            display: true,
            animate: true
        )
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
