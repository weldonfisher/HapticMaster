# Haptic Master ⚡️

[![macOS](https://img.shields.io/badge/platform-macOS-lightgrey.svg)](https://www.apple.com/macos/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

**Feel Your Mac.** Immersive Haptic Feedback for Logitech MX Master Users.

> 🌐 **Website:** [hapticmaster.vercel.app](https://hapticmaster.vercel.app/)
> 🌐 **Contact:** [chamuka.is-a.dev](https://chamuka.is-a.dev)


Haptic Master connects your macOS system events (notifications) and web browser interactions directly to your Logitech MX Master mouse's haptic motor. Experience a new layer of immersion with the "Liquid Glass" UI.

## ✨ Features

*   **System Haptics**: Feel a heartbeat or pulse when you receive a macOS notification.
*   **Web Immersion**: Tactile feedback for clicks and hover effects in your browser.
*   **Liquid Glass UI**: A modern, native macOS interface with frosted glass aesthetics.
*   **Custom Patterns**: Choose from Pulse, Double, Triple, Heartbeat, and more.
*   **Privacy First**: Runs 100% locally. No data leaves your Mac.
*   **Open Source**: Fully transparent code.

## 🛠 Requirements

*   **macOS 14.0+** (Sonoma or later).
*   **Logitech MX Master 3 / 3S / 4** (Supported Mouse).
*   **Logi Options+** app installed.

## 🚀 Installation

### 1. The Mac App
1.  Download the latest release.
2.  Move `Haptic Master.app` to your **Applications** folder.
3.  **Right-Click** the app and select **Open**. (You must do this to bypass the "Unidentified Developer" warning).
4.  Click **Open** again.
5.  Go to **System Settings > Privacy & Security > Accessibility** and allow "Haptic Master".

### 2. Browser Extensions

#### Chrome / Edge / Brave
1.  Go to `chrome://extensions`.
2.  Enable **Developer Mode** (Top Right).
3.  Click **Load Unpacked**.
4.  Select the `extension` folder from this repository.

#### Firefox
1.  Go to `about:addons`.
2.  Click the Gear Icon ⚙️ -> **Install Add-on From File...** (If you have the signed .xpi).
3.  *Or for Devs*: Go to `about:debugging`, click **Load Temporary Add-on**, and select the `manifest.json` inside the `extension_firefox` folder.

### 3. Logi Options+ Setup (Critical)
To make the mouse actually vibrate, you **must** map the trigger:

1.  Open **Logi Options+**.
2.  Go to **Smart Actions** -> **Create Smart Action**.
3.  **Trigger**: Shortcut `Cmd + Shift + Ctrl + Opt + U` (Hyper-U).
4.  **Action**: **Haptic Feedback** (Select Max Intensity).

## 💻 Development

This project uses a simple Swift script architecture.
To build the app locally:

```bash
cd HapticMaster
./build_with_icon.sh
```

This will compile the Swift sources and generate `Haptic Master.app` with the custom icon.

## 🤝 Contributing

Pull requests are welcome! Please open an issue first to discuss what you would like to change.

## 📄 License

[MIT](LICENSE) © 2026 Chamuka Dilshan.
