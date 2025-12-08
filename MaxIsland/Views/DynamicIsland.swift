import SwiftUI

struct DynamicIsland: View {
    @State private var islandState: IslandState = .compact
    @State private var isHovering = false
    @AppStorage("AppTheme") private var appTheme: AppTheme = .systemDefault
//    @FocusState private var isFocused: Bool
    
    var body: some View {
        
        ZStack {
            NotchShape(topCornerRadius: topCorner, bottomCornerRadius: bottomCorner)
                .fill(.thickMaterial)
            
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
                    
                    // LEFT SIDE BUTTON (existing state toggle)
                    Button(action: { toggleState() }) {
                        Circle()
                            .fill(islandState == .compact ? Color.green : Color.red)
                            .frame(width: 12, height: 12)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.leading, islandState == .compact ? 16 : 32)
                    .padding(.top, islandState == .compact ? 10 : 12)

                    Spacer()

                    // RIGHT SIDE BUTTON (theme toggle)
                    Button(action: {ThemeManager.shared.toggle()}) {
                        Image(systemName: appTheme == .light ? "sun.max.fill" :
                                            appTheme == .dark ? "moon.stars.fill" :
                                            "circle.lefthalf.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 12, weight: .bold))
                            .frame(width: 18, height: 18)
                            .padding(6)
                            .background(.thinMaterial)
                            .clipShape(Circle())
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.trailing, islandState == .compact ? 16 : 32)
                    .padding(.top, islandState == .compact ? 10 : 12)
                }

                Spacer()
            }


        }
            

        .onTapGesture {
            if islandState == .expanded {
                toggleState(to: .compact)
            }
        }
//        .focusable()
//        .focused($isFocused)
//        .onKeyPress(.escape) {
//            print("key press escape")
//            if islandState == .expanded {
//                toggleState(to: .compact)
//                return .handled
//            }
//            return .ignored
//        }
        
        .onHover { hovering in
              isHovering = hovering
              
              if hovering && islandState == .compact {
                  print("Expanding on hover")
                  toggleState(to: .expanded)
              }
          }
        .onChange(of: islandState) { oldValue, newValue in
            updateWindowSize()
            print("new value", newValue)
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
    //dark mode switch
    private func toggleTheme() {
            switch appTheme {
            case .systemDefault:
                appTheme = .light
            case .light:
                appTheme = .dark
            case .dark:
                appTheme = .systemDefault
            }
        applyTheme()
            print("appTheme is now", appTheme.rawValue)
        }
    private func applyTheme() {
        switch appTheme {
        case .light:
            NSApp.appearance = NSAppearance(named: .aqua)
        case .dark:
            NSApp.appearance = NSAppearance(named: .darkAqua)
        case .systemDefault:
            NSApp.appearance = nil
        }
    }

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

