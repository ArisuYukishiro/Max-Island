import SwiftUI
import AppKit

class SettingWindowController: NSWindowController {
    convenience init() {
        guard let screen = NSScreen.main else {
            self.init(window: nil)
            return
        }
        
        let screenFrame = screen.visibleFrame
        let windowWidth: CGFloat = 800
        let windowHeight: CGFloat = 600
        let xPosition = (screenFrame.width - windowWidth) / 2 + screenFrame.origin.x
        let yPosition: CGFloat

        if screenFrame.height > 1000 && screenFrame.height < 1200 {
            yPosition = (screenFrame.height - windowHeight) / 3 + screenFrame.origin.y
        } else  if screenFrame.height < 1000 {
            yPosition = (screenFrame.height - windowHeight) / 4 + screenFrame.origin.y
        } else {
            yPosition = 0
        }
        
        let settingsWindow = NSWindow(
            contentRect: NSRect(x: xPosition, y: yPosition, width: windowWidth, height: windowHeight),
            styleMask: [.titled, .closable, .resizable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        settingsWindow.title = "Max Island"
        settingsWindow.minSize = NSSize(width: 500, height: 350)
        settingsWindow.maxSize = NSSize(width: 1200, height: 800)
        settingsWindow.titlebarAppearsTransparent = true

        
        let contentView = NSHostingView(rootView: SettingView(isPresented: .constant(true)))
        settingsWindow.contentView = contentView
        
        self.init(window: settingsWindow)
    }
}
