import SwiftUI
import AppKit

class IslandLayoutManager: ObservableObject {
    static let shared = IslandLayoutManager()
    
    @Published var screenFrame: NSRect = NSScreen.main?.frame ?? .zero
    @Published var visibleWidth: CGFloat = NSScreen.main?.visibleFrame.width ?? 1440
    
    init() {
        NotificationCenter.default.addObserver(
            forName: NSApplication.didChangeScreenParametersNotification,
            object: nil,
            queue: .main
        ) { _ in
            // CANCEL any pending updates to prevent "jumping"
            NSObject.cancelPreviousPerformRequests(withTarget: self)
            
            // DELAY the update until the screen has finished flickering
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                if let screen = NSScreen.main {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                        self.screenFrame = screen.frame
                        self.visibleWidth = screen.visibleFrame.width
                    }
                }
            }
        }
    }
}
