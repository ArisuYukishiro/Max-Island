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

class IslandAnimationManager: ObservableObject {
    @Published var hasAnimationCompleted: Bool = false
    
    static let shared = IslandAnimationManager()
    
    private init() {}
}
