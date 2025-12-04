import SwiftUI

struct DynamicIsland: View {
    @State private var islandState: IslandState = .compact
    @State private var isHovering = false
    var body: some View {
        ZStack {
            NotchShape(topCornerRadius: topCorner, bottomCornerRadius: bottomCorner)
                .fill(Color.black.opacity(0.95))
            
            Group {
                switch islandState {
                case .compact:
                    CompactView()
                     .padding(.horizontal, 16)
                     .padding(.vertical, 8)
                case .expanded:
                    ExpandedView()
                        .padding(.horizontal, 24)
                }
            }
            
            VStack {
                HStack {
                    Button(action: {toggleState()}) {
                        Circle()
                            .fill(islandState == .compact ? Color.green : Color.red)
                            .frame(width: 12, height: 12)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.leading, islandState  == .compact ? 16 : 32 )
                    .padding(.top,islandState == .compact ? 10 : 12)
                    
                    Spacer()
                }
                Spacer()
            }
        }

        .onTapGesture {
            if islandState == .expanded {
                toggleState(to: .compact)
            }
        }
        
        .onHover { hovering in
              isHovering = hovering
              
              if hovering && islandState == .compact {
                  print("Expanding on hover")
                  toggleState(to: .expanded)
              }
          }
        .onChange(of: islandState) { oldValue, newValue in
            updateWindowSize()
        }
       
        .onExitCommand {
            toggleState(to: .compact)
        }
        
    }
    
    
//    private var islandWidth: CGFloat {
//        
//            switch islandState {
//            case .compact:
//                return 240
//            case .expanded:
//                return 580
//            }
//    }
    private var islandWidth: CGFloat {
        guard let screenWidth = NSScreen.main?.visibleFrame.width else {
            // fallback width
            return islandState == .compact ? 240 : 580
        }
        
        switch islandState {
        case .compact:
            // e.g., use 25% of the screen width, min 200, max 300
            return min(max(screenWidth * 0.25, 200), 300)
        case .expanded:
            // e.g., 50% of the screen width, min 400, max 600
            return min(max(screenWidth * 0.5, 400), 600)
        }
    }

    
    private var islandHeight: CGFloat {
          switch islandState {
          case .compact:
              return 37
          case .expanded:
              return 300
          }
      }
      
    private var topCorner: CGFloat {
        switch islandState {
        case .compact:
            return 8
        case .expanded:
            return 24
        }
    }
    
    private var bottomCorner: CGFloat {
        switch islandState {
        case .compact:
            return 18.5
        case .expanded:
            return 45
        }
    }
    
    private func toggleState(to newState: IslandState? = nil) {
        print("Island State", islandState)
        
        if let newState = newState {
            // Set to specific state
            islandState = newState
        } else {
            // Toggle between states
            if islandState == .compact {
                islandState = .expanded
            } else {
                islandState = .compact
            }
        }
    }
    
    private func updateWindowSize() {
        guard let window = NSApp.windows.first,
              let screen = NSScreen.main else { return }
        
        let screenFrame = screen.frame
        let newFrame = NSRect(
            x: (screenFrame.width - islandWidth) / 2,
            y: screenFrame.height - islandHeight,
            width: islandWidth,
            height: islandHeight
        )
        print(newFrame)
        
        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.25
            context.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            window.animator().setFrame(newFrame, display: true)
        }
    }
}
