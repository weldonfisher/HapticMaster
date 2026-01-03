# Haptic Master

**Feel Your Mac.** Immersive Haptic Feedback for Logitech MX Master Users.

Haptic Master connects your macOS system events (notifications) and web browser interactions directly to your Logitech MX Master mouse's haptic motor. Feel every notification, click, and hover with custom vibration patterns.

## Features

*   **System Notifications**: Feel a heartbeat or pulse when you receive a macOS notification.
*   **Web Immersion**: Get tactile feedback when clicking buttons or hovering over elements in Chrome (requires Extension).
*   **Custom Patterns**: Choose from Pulse, Double, Triple, Heartbeat, and more.
*   **Privacy First**: Runs 100% locally. No data leaves your Mac.

## Requirements

*   **macOS 14.0+** (Sonoma or later).
*   **Logitech MX Master 3 / 3S / 4** (Supported Mouse).
*   **Logi Options+** installed.

## Installation

### 1. The App
1.  Download the latest release.
2.  Move `Haptic Master.app` to your Applications folder.
3.  Open the App. You may need to bypass the security warning (Right-click > Open) as this is an open-source unsigned app.
4.  Allow Accessibility permissions when prompted.

### 2. The Extension
1.  Go to `chrome://extensions`.
2.  Enable **Developer Mode**.
3.  Click **Load Unpacked** and select the `extension` folder from this repository.

### 3. Logi Options+ Setup (Critical)
To make the mouse actually vibrate, you need to map the "Trigger Shortcut" to a Smart Action.

1.  Open **Logi Options+**.
2.  Create a **New Smart Action**.
3.  **Trigger**: Shortcut `Cmd + Shift + Ctrl + Opt + U` (Hyper-U).
4.  **Action**: **Haptic Feedback** (Select Max Intensity).

## Development

### Build from Source
This project uses a simple Swift script architecture. You don't need a complex Xcode project file.

```bash
cd HapticMaster
./build_with_icon.sh
```

This will generate `Haptic Master.app` in the current directory.

## Contributing
Pull requests are welcome! Please open an issue first to discuss what you would like to change.

## License
[MIT](LICENSE)
