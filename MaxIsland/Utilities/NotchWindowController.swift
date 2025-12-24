import SwiftUI
import AppKit

class NotchWindowController: NSWindowController {
    convenience init() {
        // Get screen dimensions
        guard let screen = NSScreen.main else {
            self.init(window: nil)
            return
        }
        let screenSafe = screen.visibleFrame
        let screenWidth = screenSafe.width
        let screenFrame = screen.frame
        let notchWidth: CGFloat
        let notchHeight: CGFloat
        
        if screenWidth >= 2560 {
            notchWidth = 350
            notchHeight = 42
        } else if screenWidth >= 1800{
            notchWidth = 300
            notchHeight = 38
        } else if screenWidth >= 1400 {
            notchWidth = 250
            notchHeight = 32
        } else {
            notchWidth = max(screenWidth * 0.15, 150)
            notchHeight = 32
        }
        
        // Position at top center (where notch is)
        let windowRect = NSRect(
            x: (screenFrame.width - notchWidth) / 2,
            y: screenFrame.height - notchHeight,
            width: notchWidth,
            height: notchHeight
        )
        
        // Create window
        let window = NotchWindow(
            contentRect: windowRect,
            styleMask: [.borderless, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        
        // Window configuration
        window.isOpaque = false
        window.backgroundColor = .clear
        window.level = .statusBar
        window.collectionBehavior = [.canJoinAllSpaces, .stationary, .ignoresCycle]
        window.isMovableByWindowBackground = false
        window.hasShadow = false
        
        window.acceptsMouseMovedEvents = true
        window.ignoresMouseEvents = false
        
        // Set SwiftUI content
        let contentView = NSHostingView(rootView: DynamicIsland())
        contentView.frame = window.contentView?.bounds ?? .zero
        contentView.autoresizingMask = [.width, .height]
        window.contentView = contentView
        
        self.init(window: window)
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
