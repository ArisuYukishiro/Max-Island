import SwiftUI

func handleKeyDown(
    proxy: CGEventTapProxy,
    type: CGEventType,
    cgEvent: CGEvent,
    userInfo: UnsafeMutableRawPointer?
) -> Unmanaged<CGEvent>? {
   
    if let nsEvent = NSEvent(cgEvent: cgEvent),
       nsEvent.type == .keyDown {
        // check if CMD pressed
        let cmdPressed = nsEvent.modifierFlags.contains(.command)
        let pressedChar = nsEvent.charactersIgnoringModifiers?.lowercased() ?? ""
        
        print("key press char", pressedChar)
        if cmdPressed && pressedChar == "h" {
            print("Command+H pressed")
            return nil
        }
    }
    // Let all other keystrokes pass
    return Unmanaged.passUnretained(cgEvent)
}
