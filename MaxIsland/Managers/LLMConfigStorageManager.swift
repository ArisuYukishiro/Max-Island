//
//  LLMConfigStorageManager.swift
//  MaxIsland
//
//  Created by Sovannsak Yours on 17/12/25.
//

import SwiftUI

class LLMConfigManager: ObservableObject {
    
    static let shared = LLMConfigManager()
    @Published var selectedProvider: LLMProvider = .claude
    @Published var apiKeys: [LLMProvider: String] = [:]
    @Published var selectedModel: String = ""
    @Published var showApiKey: Bool = false
    
    var provider: LLMProvider {
        selectedProvider
    }
        
    var currentAPIKey: String {
        apiKeys[selectedProvider] ?? ""
    }
    
    func saveConfigLLM() {
        print("Value Saved: ",printAllVariables())
        UserDefaults.standard.set(selectedProvider.rawValue, forKey: "selectedProvider")
        UserDefaults.standard.set(selectedModel, forKey: "selectedModel")
        
        let keysData = try? JSONEncoder().encode(apiKeys)
        UserDefaults.standard.set(keysData, forKey: "apiKeys")
    }
    
    func loadConfigLLM() {
        if let providerRaw = UserDefaults.standard.string(forKey: "selectedProvider"),
           let provider = LLMProvider(rawValue: providerRaw) {
            selectedProvider = provider
        }
        
        if let model = UserDefaults.standard.string(forKey: "selectedModel") {
            selectedModel = model
        }
        
        if let keysData = UserDefaults.standard.data(forKey: "apiKeys"),
           let keys = try? JSONDecoder().decode([LLMProvider: String].self, from: keysData) {
            apiKeys = keys
        }
    }
    
     func getProviderForModel(_ modelId: String) -> LLMProvider {
        for provider in LLMProvider.allCases {
            if provider.models.contains(where: { $0.id == modelId }) {
                return provider
            }
        }
        return selectedProvider
    }
    
     func getActiveModel() -> LLMModel? {
        for provider in LLMProvider.allCases {
            if let model = provider.models.first(where: { $0.id == selectedModel }) {
                return model
            }
        }
        return nil
    }
    
    func printAllVariables() {
        print("========== LLM Configuration ==========")
        print("Selected Provider: \(selectedProvider.rawValue)")
        print("Selected Model: \(selectedModel)")
        print("Current API Key: \(currentAPIKey.isEmpty ? "[Empty]" : "[Set - \(currentAPIKey.prefix(10))...]")")
        print("\nAll API Keys:")
        if apiKeys.isEmpty {
            print("  [No API keys configured]")
        } else {
            for (provider, key) in apiKeys {
                let maskedKey = key.isEmpty ? "[Empty]" : "[\(key.prefix(10))...\(key.suffix(4))]"
                print("  \(provider.rawValue): \(maskedKey)")
            }
        }
        print("======================================")
    }
}
