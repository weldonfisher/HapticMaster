#!/bin/bash

# Configuration
APP_NAME="Haptic Master"
SOURCE_ICON="../extension/icon.png"
ICON_NAME="AppIcon"
OUTPUT_DIR="build"

echo "🚀 Starting Build for $APP_NAME..."

# 1. Cleanup
rm -rf "$OUTPUT_DIR"
mkdir -p "$OUTPUT_DIR"

# 2. Create Icon
echo "🎨 Generating App Icon..."
mkdir "$OUTPUT_DIR/$ICON_NAME.iconset"

# Resize images
sips -z 16 16     "$SOURCE_ICON" --out "$OUTPUT_DIR/$ICON_NAME.iconset/icon_16x16.png" > /dev/null
sips -z 32 32     "$SOURCE_ICON" --out "$OUTPUT_DIR/$ICON_NAME.iconset/icon_16x16@2x.png" > /dev/null
sips -z 32 32     "$SOURCE_ICON" --out "$OUTPUT_DIR/$ICON_NAME.iconset/icon_32x32.png" > /dev/null
sips -z 64 64     "$SOURCE_ICON" --out "$OUTPUT_DIR/$ICON_NAME.iconset/icon_32x32@2x.png" > /dev/null
sips -z 128 128   "$SOURCE_ICON" --out "$OUTPUT_DIR/$ICON_NAME.iconset/icon_128x128.png" > /dev/null
sips -z 256 256   "$SOURCE_ICON" --out "$OUTPUT_DIR/$ICON_NAME.iconset/icon_128x128@2x.png" > /dev/null
sips -z 256 256   "$SOURCE_ICON" --out "$OUTPUT_DIR/$ICON_NAME.iconset/icon_256x256.png" > /dev/null
sips -z 512 512   "$SOURCE_ICON" --out "$OUTPUT_DIR/$ICON_NAME.iconset/icon_256x256@2x.png" > /dev/null
sips -z 512 512   "$SOURCE_ICON" --out "$OUTPUT_DIR/$ICON_NAME.iconset/icon_512x512.png" > /dev/null
sips -z 1024 1024 "$SOURCE_ICON" --out "$OUTPUT_DIR/$ICON_NAME.iconset/icon_512x512@2x.png" > /dev/null

# Convert to ICNS
iconutil -c icns "$OUTPUT_DIR/$ICON_NAME.iconset"

# 3. Create App Bundle Structure
echo "📦 Creating Bundle..."
mkdir -p "$OUTPUT_DIR/$APP_NAME.app/Contents/MacOS"
mkdir -p "$OUTPUT_DIR/$APP_NAME.app/Contents/Resources"

# Move Icon
mv "$OUTPUT_DIR/$ICON_NAME.icns" "$OUTPUT_DIR/$APP_NAME.app/Contents/Resources/"

# 4. Create Info.plist
echo "📝 Writing Info.plist..."
cat > "$OUTPUT_DIR/$APP_NAME.app/Contents/Info.plist" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>$APP_NAME</string>
    <key>CFBundleIconFile</key>
    <string>$ICON_NAME</string>
    <key>CFBundleIdentifier</key>
    <string>com.chamuka.hapticmaster</string>
    <key>CFBundleName</key>
    <string>$APP_NAME</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0</string>
    <key>LSUIElement</key>
    <true/>
    <key>NSAppleEventsUsageDescription</key>
    <string>To trigger haptic feedback shortcuts.</string>
</dict>
</plist>
EOF

# 5. Compile Swift Code
echo "🔨 Compiling Swift Code..."
swiftc -o "$OUTPUT_DIR/$APP_NAME.app/Contents/MacOS/$APP_NAME" \
    HapticMasterApp.swift \
    ContentView.swift \
    HapticEngine.swift \
    WebServer.swift \
    NotificationWatcher.swift \
    -target arm64-apple-macosx14.0

# 6. Sign Code
echo "✍️ Signing App..."
codesign --force --deep --sign - "$OUTPUT_DIR/$APP_NAME.app"

# 7. Move to top level
mv "$OUTPUT_DIR/$APP_NAME.app" .
rm -rf "$OUTPUT_DIR"

echo "✅ Build Complete!"
echo "You can now run '$APP_NAME.app' directly."
