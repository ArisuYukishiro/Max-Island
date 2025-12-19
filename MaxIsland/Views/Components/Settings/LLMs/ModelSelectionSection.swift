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
            
            VStack(spacing: 8) {
                ForEach(llmConfigManager.provider.models) { model in
                    ModelRow(
                        model: model,
                        isSelected: llmConfigManager.selectedModel == model.id
                    ) {
                        llmConfigManager.selectedModel = model.id
                    }
                }
            }
        }
        .padding(16)
        .background(Color(nsColor: .controlBackgroundColor))
        .cornerRadius(8)
    }
}
