# MaxIsland

A macOS Dynamic Island with a built-in AI chat — ask anything without leaving what you're doing.

## What it does

Sits at the top center of your screen as a small floating island. Click it to expand and chat with AI. Switch tabs while working without losing your place.

## Setup

Copy the config and fill in your API details:

```bash
cp MaxIsland/Config/Secrets.xcconfig.example MaxIsland/Config/Secrets.xcconfig
```

Then edit `Secrets.xcconfig` with your API base URL.

## Requirements

- macOS 26.0+
- Xcode 26.1.1+
