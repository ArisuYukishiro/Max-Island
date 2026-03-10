import SwiftUI

struct ModelSelectionSection: View {
    @ObservedObject var llmConfigManager: LLMConfigManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Available Models")
                .font(.system(size: 13, weight: .semibold))
            
            Text("Select a model to use for your chats")
                .font(.system(size: 12))
                .foregroundColor(.secondary)
            
            if llmConfigManager.providers.isEmpty {
                Text("No models available. Please check your connection.")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                    .padding()
            } else {
                VStack(spacing: 8) {
                    let models = llmConfigManager.getModelsForProvider(llmConfigManager.selectedProvider)
                    
                    ForEach(models, id: \.modelName) { model in
                        ModelRow(
                            model: model,
                            isSelected: llmConfigManager.selectedModel == model.modelName
                        ) {
                            llmConfigManager.selectedModel = model.modelName
                        }
                    }
                }
            }
        }
        .padding(16)
        .background(Color(nsColor: .controlBackgroundColor))
        .cornerRadius(8)
    }
}

