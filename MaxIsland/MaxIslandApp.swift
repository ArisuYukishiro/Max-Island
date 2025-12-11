import SwiftUI

@main
struct DynamicIslandApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var notchWindowController: NotchWindowController?
    var settingWindowController: NSWindowController?
    var eventTap: CFMachPort?

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)

        ChatStorageManager.shared.clearMessages()

        notchWindowController = NotchWindowController()
        notchWindowController?.showWindow(nil)
        
        //observer for setting window
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(openSettings),
            name: NSNotification.Name("OpenSettings"),
            object: nil
        )
    }
    
    @objc func openSettings() {
        if settingWindowController == nil {
            settingWindowController = SettingWindowController()
        }
        
        settingWindowController?.showWindow(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
