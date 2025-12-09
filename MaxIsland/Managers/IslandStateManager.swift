//
//  IslandStateManager.swift
//  MaxIsland
//
//  Created by Sovannsak Yours on 9/12/25.
//

import SwiftUI

class IslandStateManager: ObservableObject {
    @Published var islandState: IslandState = .compact
    
    static let shared = IslandStateManager()
    
    private init() {}
}

class IslandAnimation: ObservableObject{
    @Published var isAnimationLoading: Bool = false
    
    static let shared = IslandAnimation()
    
    private init() {}
}
