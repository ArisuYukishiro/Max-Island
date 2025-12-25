import SwiftUI

struct DynamicIsland: View {
    @State private var isHovering = false

    @AppStorage("AppTheme") private var appTheme: AppTheme = .systemDefault
    @ObservedObject private var themeManager = ThemeManager.shared
    @ObservedObject private var stateManager = IslandStateManager.shared
    @ObservedObject private var islandAnimation = IslandAnimationManager.shared
    @ObservedObject var layout = IslandLayoutManager.shared

    var body: some View {
        ZStack {
            if stateManager.islandState == .expanded {
                // Inner shadow
                NotchShape(topCornerRadius: topCorner, bottomCornerRadius: bottomCorner)
                    .fill(themeManager.currentTheme == .dark ? Color.black.opacity(0.7) : Color.white.opacity(0.7))
                    .blur(radius: 4)
                    .offset(y: 2)
                    .padding(.bottom, 10)
            }
            
            // Main shape
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
            
            if stateManager.islandState == .expanded &&  islandAnimation.hasAnimationCompleted == false {
                VStack {
                    HStack(spacing: 12 ) {
                        Spacer()

                        Button(action: {
                            stateManager.islandState = .compact
                        }){
                            Image(systemName: "house.fill")
                                .foregroundColor(themeManager.currentTheme == .dark ? .white : .black)
                                .font(.system(size: 14, weight: .bold))
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding(.horizontal, 8)
                        .padding(.vertical, 6)
                        .background(
                         RoundedRectangle(cornerRadius: 8)
                        .fill(themeManager.currentTheme == .dark
                         ? Color.white.opacity(0.15) : Color.black.opacity(0.08)))
                        .keyboardShortcut("h", modifiers: [.command])
                                
                                                
                        Button(action: {
                            NotificationCenter.default.post(name: NSNotification.Name("OpenSettings"), object: nil)
                        }) {
                            Image(systemName: "gearshape.fill")
                                .foregroundColor(themeManager.currentTheme == .dark ? .white : .black)
                                .font(.system(size: 14, weight: .bold))
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding(.horizontal, 8)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(themeManager.currentTheme == .dark
                                      ? Color.white.opacity(0.15)
                                      : Color.black.opacity(0.08))
                        )
                        .keyboardShortcut(",", modifiers: [.command, .shift])
                    }
                    .padding(.horizontal, 48)
                    .padding(.top, 12)
                    
                    Spacer()
                }
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
                  toggleState(to: .expanded)
              }
          }
        
        .onChange(of: stateManager.islandState) { oldValue, newValue in
            updateWindowSize()
        }
        
        .onExitCommand {
            toggleState(to: .compact)
        }
        .onChange(of: layout.visibleWidth) { _, _ in updateWindowSize() }
        
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
//        guard let screenWidth = NSScreen.main?.visibleFrame.width else {
//            return stateManager.islandState == .compact ? 240 : 580
//        }
        
        let screenWidth = layout.visibleWidth
        print("screen width", screenWidth)
        switch stateManager.islandState {
        case .compact:
            if screenWidth >= 2560 {
                return 350
            } else if screenWidth >= 1800 {
                return 300
            } else if screenWidth >= 1400 {
                return 250
            } else {
                return max(screenWidth * 0.15, 150)
            }
        case .expanded:
            if screenWidth >= 2560 {
                return 650
            } else if screenWidth >= 1800 {
                return 600
            } else if screenWidth >= 1400 {
                return 600
            } else {
                return max(screenWidth * 0.4, 400)
            }
        }
    }

    
    private var islandHeight: CGFloat {
//        guard let screen = NSScreen.main else {
//            return stateManager.islandState == .compact ? 32 : 300
//        }
        
        let screenWidth = layout.visibleWidth
        
        switch stateManager.islandState {
        case .compact:
            if screenWidth >= 2560 {
                return 40
            } else if screenWidth >= 1800 {
                return 38
            } else if screenWidth >= 1400 {
                return 32
            } else {
                return 32
            }
            
        case .expanded:
            if screenWidth >= 2560 {
                return 350
            } else if screenWidth >= 1800 {
                return 320
            } else if screenWidth >= 1400 {
                return 300
            } else {
                return 280
            }
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
            return 16
        case .expanded:
            return 16
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

