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
//        .onTapGesture {
//            toggleState()
//        }
        .onHover { hovering in
            isHovering = hovering
        }
        .onChange(of: islandState) { oldValue, newValue in
            updateWindowSize()
        }
    }
    
    private var islandWidth: CGFloat {
            switch islandState {
            case .compact:
                return 240
            case .expanded:
                return 500
            }
    }
    
    private var islandHeight: CGFloat {
          switch islandState {
          case .compact:
              return 37
          case .expanded:
              return 200
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
    
    private func toggleState() {
        print("Island State", islandState);
        if islandState == .compact {
            islandState = .expanded
        } else {
            islandState = .compact
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
