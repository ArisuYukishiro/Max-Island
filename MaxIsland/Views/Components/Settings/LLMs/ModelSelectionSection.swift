import SwiftUI

struct ModelSelectionSection: View {
    let provider: LLMProvider
    @Binding var selectedModel: String
    let getProviderForModel: (String) -> LLMProvider
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Available Models")
                .font(.system(size: 13, weight: .semibold))
            
            Text("Select a model to use for your chats")
                .font(.system(size: 12))
                .foregroundColor(.secondary)
            
            VStack(spacing: 8) {
                ForEach(provider.models) { model in
                    ModelRow(
                        model: model,
                        isSelected: selectedModel == model.id
                    ) {
                        selectedModel = model.id
                    }
                }
            }
        }
        .padding(16)
        .background(Color(nsColor: .controlBackgroundColor))
        .cornerRadius(8)
    }
}
