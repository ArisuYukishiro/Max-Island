import SwiftUI
import AppKit

class SettingWindowController: NSWindowController {
    convenience init() {
        let settingsWindow = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 600, height: 400),
            styleMask: [.titled, .closable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        settingsWindow.title = "Max Island"
        settingsWindow.center()
        
        settingsWindow.titlebarAppearsTransparent = true
        settingsWindow.isOpaque = false
        settingsWindow.backgroundColor = .clear
        
        let visualEffectView = NSVisualEffectView()
        visualEffectView.material = .hudWindow
        visualEffectView.blendingMode = .behindWindow
        visualEffectView.state = .active
            
        let contentView = NSHostingView(rootView: SettingView(isPresented: .constant(true)))
        contentView.autoresizingMask = [.width, .height]
         
        visualEffectView.addSubview(contentView)
        contentView.frame = visualEffectView.bounds
         
        settingsWindow.contentView = visualEffectView
         
        self.init(window: settingsWindow)
    }
}
