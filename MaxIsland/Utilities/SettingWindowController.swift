import SwiftUI
import AppKit

class SettingWindowController: NSWindowController {
    convenience init() {
        let settingsWindow = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 700, height: 400),
            styleMask: [.titled, .closable, .resizable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        settingsWindow.title = "Max Island"
        settingsWindow.center()
        settingsWindow.minSize = NSSize(width: 500, height: 350)
        settingsWindow.maxSize = NSSize(width: 1200, height: 800)
        settingsWindow.titlebarAppearsTransparent = true

        
        let contentView = NSHostingView(rootView: SettingView(isPresented: .constant(true)))
        settingsWindow.contentView = contentView
        
        self.init(window: settingsWindow)
    }
}
