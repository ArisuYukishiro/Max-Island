//
//  LLMConfigStorageManager.swift
//  MaxIsland
//
//  Created by Sovannsak Yours on 17/12/25.
//

import SwiftUI


class LLMConfigStorageManager {
    
    static let shared = LLMConfigStorageManager()
    private let LLMConfigKey = "LLMConfig"
    
    func saveLLMConfig(_ config : LLMModel){
        if let encoded = try? JSONEncoder().encode(config) {
            UserDefaults.standard.set(encoded, forKey:LLMConfigKey)
        }
    }
    
    func loadLLMConfig() -> LLMModel? {
        guard let data = UserDefaults.standard.data(forKey: LLMConfigKey),
              let model = try? JSONDecoder().decode(LLMModel.self, from: data) else {
            return nil
        }
        return model
    }
    
    func clearLLMConfigKey() {
        UserDefaults.standard.removeObject(forKey: LLMConfigKey)
    }
    
}
