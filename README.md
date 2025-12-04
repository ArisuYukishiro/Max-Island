# MaxIsland

A macOS application that brings the Dynamic Island experience to your Mac with an integrated AI chat interface.

## Overview

MaxIsland creates a floating, interactive Dynamic Island-style interface that sits at the top of your screen. It features a compact mode for minimal screen footprint and an expanded mode with a full-featured AI chat assistant that supports markdown rendering.

## Features

- **Dynamic Island Interface**: iPhone-inspired Dynamic Island design adapted for macOS
- **Two Display Modes**:
  - Compact mode (240x37) for minimal screen presence
  - Expanded mode (580x300) for full chat interaction
- **AI Chat Integration**: Built-in chat interface with API connectivity
- **Markdown Support**: Rich text formatting in chat messages
- **Smooth Animations**: Fluid transitions between compact and expanded states
- **Always Accessible**: Lives in the menu bar area for quick access
- **Custom Notch Shape**: Authentic notch-style UI with rounded corners

## Requirements

- macOS 13.0 or later
- Xcode 14.0 or later (for building from source)

## Installation

### Building from Source

1. Clone the repository:
```bash
git clone <repository-url>
cd MaxIsland
```

2. Open the project in Xcode:
```bash
open MaxIsland.xcodeproj
```

3. Configure your API endpoint in `Config.swift`

4. Build and run the project (⌘R)

## Configuration

Before running the app, you need to configure the API endpoint:

1. Open `Config.swift`
2. Update the `baseURL` with your chat API endpoint
3. Ensure your API follows the expected request/response format:

**Request Format:**
```json
{
  "message": "Your message here"
}
```

**Response Format:**
```json
{
  "response": "AI response here"
}
```

## Usage

1. Launch MaxIsland - the app will appear at the top center of your screen in compact mode
2. Click the green/red indicator circle to toggle between compact and expanded modes
3. In expanded mode, use the chat interface to interact with your AI assistant
4. The app runs as a menu bar accessory and won't appear in the Dock

## Project Structure

```
MaxIsland/
├── MaxIsland/
│   ├── MaxIslandApp.swift          # App entry point and delegate
│   ├── ContentView.swift            # Main content view
│   ├── Config.swift                 # API configuration
│   ├── Models/
│   │   ├── IslandContent.swift     # Island state models
│   │   └── ChatModel.swift         # Chat data models
│   ├── ViewModels/
│   │   └── ChatViewModel.swift     # Chat logic and state
│   ├── Views/
│   │   ├── DynamicIsland.swift     # Main Dynamic Island view
│   │   ├── CompactView.swift       # Compact state UI
│   │   ├── ExpandedView.swift      # Expanded state UI
│   │   └── Components/
│   │       ├── ChatInput.swift     # Chat input field
│   │       ├── ChatMessage.swift   # Chat message display
│   │       ├── MessageBubble.swift # Individual message bubbles
│   │       ├── LoadingView.swift   # Loading indicator
│   │       ├── ErrorView.swift     # Error display
│   │       └── Shapes/
│   │           ├── NotchShape.swift    # Custom notch shape
│   │           └── RoundedCorner.swift # Custom corner radius
│   ├── Services/
│   │   └── ChatApiService.swift    # API communication
│   └── Utilities/
│       └── NotchWindowController.swift # Window management
└── README.md
```

## Architecture

The app follows the MVVM (Model-View-ViewModel) architecture pattern:

- **Models**: Define data structures for chat messages and island states
- **Views**: SwiftUI views for the UI components
- **ViewModels**: Handle business logic and state management
- **Services**: Manage external API communications
- **Utilities**: Helper classes for window management

## Development

### Key Technologies

- SwiftUI for the user interface
- Async/await for API calls
- Combine for reactive state management
- URLSession for network requests

### Running Tests

```bash
# Run unit tests
⌘U in Xcode

# Or via command line
xcodebuild test -scheme MaxIsland
```

## Troubleshooting

**Island not appearing:**
- Check that accessibility permissions are granted
- Ensure the app is running (check Activity Monitor)

**Chat not working:**
- Verify API endpoint configuration in Config.swift
- Check network connectivity
- Review console logs for error messages

**Window positioning issues:**
- Try restarting the app
- Check display settings if using multiple monitors

## License

[Add your license here]

## Contributing

[Add contribution guidelines here]

## Acknowledgments

Inspired by Apple's Dynamic Island feature on iPhone 14 Pro and later models.
