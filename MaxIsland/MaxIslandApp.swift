import SwiftUI

@main
struct DynamicIslandApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        Settings {
            EmptyView()
        }
        WindowGroup {
            
                ContentView()
                    .frame(minWidth: 500, minHeight: 350)
            }
        
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var notchWindowController: NotchWindowController?
    var eventTap: CFMachPort?

    
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        
        // current the chat got clear when user terminate and luanch new application, find a way to clear memory when application chat terminated
        ChatStorageManager.shared.clearMessages()

        
        notchWindowController = NotchWindowController()
        notchWindowController?.showWindow(nil)
        
        
    }
}
