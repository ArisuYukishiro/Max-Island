//
//  LLMConfigStorageManager.swift
//  MaxIsland
//
//  Created by Sovannsak Yours on 17/12/25.
//

import SwiftUI

class LLMConfigManager: ObservableObject {
    
    static let shared = LLMConfigManager()
    
    @Published var selectedProvider: String = "antrophic"
    @Published var apiKeys: [String: String] = [:]
    @Published var selectedModel: String = ""
    @Published var showApiKey: Bool = false
    @Published var providers: [String: [ModelInfo]] = [:]
        
    var currentAPIKey: String {
        apiKeys[selectedProvider] ?? ""
    }
    
    
    func updateProviders(_ providersData: [String: [ModelInfo]]) {
         self.providers = providersData
         saveProvidersToUserDefaults()
     }
     
     func getProviders() -> [String] {
         return Array(providers.keys).sorted()
     }
     
     func getModelsForProvider(_ provider: String) -> [ModelInfo] {
         return providers[provider] ?? []
     }
     
     func getModelInfo(modelName: String) -> ModelInfo? {
         for (_, models) in providers {
             if let model = models.first(where: { $0.modelName == modelName }) {
                 return model
             }
         }
         return nil
     }
     
    private func saveProvidersToUserDefaults() {
        if let encoded = try? JSONEncoder().encode(providers) {
            UserDefaults.standard.set(encoded, forKey: "providers")
        }
    }
    
    private func loadProvidersFromUserDefaults() {
        if let data = UserDefaults.standard.data(forKey: "providers"),
           let decoded = try? JSONDecoder().decode([String: [ModelInfo]].self, from: data) {
            providers = decoded
        }
    }
    
    func saveConfigLLM() {
        print("Value Saved: ",printAllVariables())
        UserDefaults.standard.set(selectedProvider, forKey: "selectedProvider")
        UserDefaults.standard.set(selectedModel, forKey: "selectedModel")
        
        let keysData = try? JSONEncoder().encode(apiKeys)
        UserDefaults.standard.set(keysData, forKey: "apiKeys")
        
        saveProvidersToUserDefaults()
    }
    
    func loadConfigLLM() {
        if let provider = UserDefaults.standard.string(forKey: "selectedProvider") {
            selectedProvider = provider
        }
        
        if let model = UserDefaults.standard.string(forKey: "selectedModel") {
            selectedModel = model
        }
        
        if let keysData = UserDefaults.standard.data(forKey: "apiKeys"),
           let keys = try? JSONDecoder().decode([String: String].self, from: keysData) {
            apiKeys = keys
        }
        
        loadProvidersFromUserDefaults()
    }
    
    func getProviderForModel(_ modelName: String) -> String? {
        for (provider, models) in providers {
            if models.contains(where: { $0.modelName == modelName }) {
                return provider
            }
        }
        return nil
    }
    
    func getActiveModel() -> ModelInfo? {
        for (_, models) in providers {
            if let model = models.first(where: { $0.modelName == selectedModel }) {
                return model
            }
        }
        
        if selectedModel.isEmpty, let firstProvider = providers.keys.sorted().first {
            return providers[firstProvider]?.first
        }
        
        return nil
    }
    
    func printAllVariables() {
        print("========== LLM Configuration ==========")
        print("Selected Provider: \(selectedProvider)")
        print("Selected Model: \(selectedModel)")
        print("Current API Key: \(currentAPIKey.isEmpty ? "[Empty]" : "[Set - \(currentAPIKey.prefix(10))...]")")
        print("\nAll API Keys:")
        if apiKeys.isEmpty {
            print("  [No API keys configured]")
        } else {
            for (providers, key) in apiKeys {
                let maskedKey = key.isEmpty ? "[Empty]" : "[\(key.prefix(10))...\(key.suffix(4))]"
                print("  \(providers): \(maskedKey)")
            }
        }
        print("======================================")
    }
}
