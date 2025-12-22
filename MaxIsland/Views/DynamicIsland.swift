import SwiftUI

struct DynamicIsland: View {
    @State private var isHovering = false

    @AppStorage("AppTheme") private var appTheme: AppTheme = .systemDefault
    @ObservedObject private var themeManager = ThemeManager.shared
    @ObservedObject private var stateManager = IslandStateManager.shared
    @ObservedObject private var islandAnimation = IslandAnimationManager.shared

    var body: some View {
        ZStack {
            NotchShape(topCornerRadius: topCorner, bottomCornerRadius: bottomCorner)
                .fill(themeManager.currentTheme == .dark ? .black : .white)
            
            
//            Spacer()
//                .frame(
//                 width: islandWidth,
//                 height: islandHeight
//                )
//                .glassEffect(
//                .regular,
//                    in: NotchShape(
//                        topCornerRadius: topCorner,
//                        bottomCornerRadius: bottomCorner
//                     )
//                )
//                .animation(.spring(response: 0.4, dampingFraction: 0.8), value: islandState)
                  
        
            Group {
                switch stateManager.islandState {
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
                    Spacer()
                    
                    Button(action: {
                        NotificationCenter.default.post(name: NSNotification.Name("OpenSettings"), object: nil)
                    }) {
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(themeManager.currentTheme == .dark ? .white : .black)
                            .font(.system(size: 14, weight: .bold))
                            .background(.thinMaterial)
                            .clipShape(Circle())
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.trailing, stateManager.islandState == .compact ? 16 : 32)
                    .padding(.top, stateManager.islandState == .compact ? 6 : 8)
                    .keyboardShortcut(",", modifiers: [.command, .shift])
                }
                
                Spacer()
            }
        }

        .onTapGesture {
            if stateManager.islandState == .expanded {
                toggleState(to: .compact)
            }
        }
        
        .onHover { hovering in
              isHovering = hovering
              
              if hovering && stateManager.islandState == .compact {
                  print("Expanding on hover")
                  toggleState(to: .expanded)
              }
          }
        
        .onChange(of: stateManager.islandState) { oldValue, newValue in
            updateWindowSize()
            print("new value", newValue)
        }
        
        .onExitCommand {
            toggleState(to: .compact)
        }
        
    }
    
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
            return stateManager.islandState == .compact ? 240 : 580
        }
        
        print("screen width", screenWidth)
        switch stateManager.islandState {
        case .compact:
            return min(max(screenWidth * 0.25, 150), 250)
        case .expanded:
            return min(max(screenWidth * 0.5, 400), 600)
        }
    }

    
    private var islandHeight: CGFloat {
          switch stateManager.islandState {
          case .compact:
              return 32
          case .expanded:
              return 300
          }
      }
      
    private var topCorner: CGFloat {
        switch stateManager.islandState {
        case .compact:
            return 8
        case .expanded:
            return 24
        }
    }
    
    private var bottomCorner: CGFloat {
        switch stateManager.islandState {
        case .compact:
            return 18.5
        case .expanded:
            return 45
        }
    }
    
    private func toggleState(to newState: IslandState? = nil) {
        print("Island State", stateManager.islandState)
        
        if let newState = newState {
            stateManager.islandState = newState
        } else {
            if stateManager.islandState == .compact {
                stateManager.islandState = .expanded
            } else {
                stateManager.islandState = .compact
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
        
        islandAnimation.hasAnimationCompleted = true
        
        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.5
            context.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            window.animator().setFrame(newFrame, display: true)
        } completionHandler: {
            if stateManager.islandState == .expanded {
                DispatchQueue.main.async {
                    islandAnimation.hasAnimationCompleted = false
                    print("Expansion animation completed successfully")
                }
            }
        }
    }
}

