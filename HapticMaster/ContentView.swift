import SwiftUI

struct ContentView: View {
    // --- State Objects ---
    @ObservedObject var webServer = WebServer.shared
    
    // --- Settings Storage ---
    @AppStorage("systemNotificationsEnabled") private var systemNotificationsEnabled: Bool = true
    @AppStorage("notificationPattern") private var notificationPattern: String = "pulse"
    @AppStorage("allowWebHaptics") private var allowWebHaptics: Bool = true
    
    // --- Data ---
    let patterns: [String: String] = [
        "single": "Single",
        "double": "Double",
        "pulse": "Pulse",
        "heartbeat": "Heartbeat",
        "triple": "Triple"
    ]
    
    var sortedKeys: [String] { patterns.keys.sorted() }
    
    var body: some View {
        ZStack {
            // LAYER 1: Modern Solid/Subtle Background
            // Using a very subtle off-white/gray for a clean look, or just standard window vibrancy
            Color(nsColor: .windowBackgroundColor)
                .ignoresSafeArea()
            
            // LAYER 2: Content
            VStack(spacing: 0) {
                // Header
                HStack {
                    Image(systemName: "magicmouse.fill")
                        .font(.title2)
                        .foregroundStyle(.primary)
                    
                    Text("Haptic Master")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundStyle(.primary)
                    
                    Spacer()
                }
                .padding()
                
                ScrollView {
                    VStack(spacing: 16) {
                        
                        // SECTION 1: System Notifications
                        GlassCard {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Image(systemName: "bell.badge.fill")
                                        .foregroundStyle(.orange)
                                        .font(.title3)
                                    
                                    Text("System Notifications")
                                        .font(.headline)
                                        .foregroundStyle(.primary)
                                    
                                    Spacer()
                                    
                                    Toggle("", isOn: $systemNotificationsEnabled)
                                        .toggleStyle(.switch)
                                        .tint(.blue)
                                }
                                
                                if systemNotificationsEnabled {
                                    Divider().opacity(0.5)
                                    
                                    HStack {
                                        Text("Vibration Type")
                                            .font(.subheadline)
                                            .foregroundStyle(.secondary)
                                        
                                        Spacer()
                                        
                                        Menu {
                                            ForEach(sortedKeys, id: \.self) { key in
                                                Button(action: {
                                                    notificationPattern = key
                                                    // Play immediately for preview
                                                    HapticEngine.shared.playPattern(key)
                                                }) {
                                                    if notificationPattern == key {
                                                        Label(patterns[key] ?? key, systemImage: "checkmark")
                                                    } else {
                                                        Text(patterns[key] ?? key)
                                                    }
                                                }
                                            }
                                        } label: {
                                            HStack {
                                                Text(patterns[notificationPattern] ?? notificationPattern)
                                                Image(systemName: "chevron.up.chevron.down")
                                                    .font(.caption)
                                            }
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(.ultraThinMaterial)
                                            .cornerRadius(6)
                                        }
                                        .menuStyle(.borderlessButton)
                                        .frame(width: 120)
                                    }
                                }
                            }
                        }
                        
                        // SECTION 2: Web Browser
                        GlassCard {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Image(systemName: "globe")
                                        .foregroundStyle(.blue)
                                        .font(.title3)
                                    
                                    Text("Web Browser")
                                        .font(.headline)
                                        .foregroundStyle(.primary)
                                    
                                    Spacer()
                                    
                                    Toggle("", isOn: $allowWebHaptics)
                                        .toggleStyle(.switch)
                                        .tint(.blue)
                                }
                                
                                // Status Indicator
                                HStack(spacing: 6) {
                                    Circle()
                                        .fill(webServer.isConnected ? Color.green : Color.red)
                                        .frame(width: 8, height: 8)
                                    
                                    Text(webServer.status)
                                        .font(.caption2)
                                        .foregroundStyle(.secondary)
                                    
                                    Spacer()
                                    
                                    if let last = webServer.lastSignalTime {
                                        Text("Signal: \(last.formatted(date: .omitted, time: .standard))")
                                            .font(.caption2)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                                .padding(.top, 4)
                                
                                if allowWebHaptics {
                                    Divider().opacity(0.5)
                                    
                                    Text("Customize patterns in your browser extension.")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                    
                                    Link(destination: URL(string: "https://drive.google.com/drive/folders/1juzgRI2uHdNW6ohkhDUIfd6TKoH-uaGa?usp=sharing")!) {
                                        HStack {
                                            Text("Download Extension")
                                                .fontWeight(.semibold)
                                            Image(systemName: "arrow.down.circle")
                                        }
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 8)
                                        .background(Color.blue)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
                
                // Footer
                GlassCard(padding: 10) {
                    HStack {
                        Link("Connect", destination: URL(string: "https://chamuka.is-a.dev")!)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                        Text("•").foregroundStyle(.secondary.opacity(0.5))
                        
                        Link("Buy me a coffee", destination: URL(string: "https://buymeacoffee.com/chamuka")!)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                        Spacer()
                        
                        Button(action: { NSApplication.shared.terminate(nil) }) {
                            Image(systemName: "power")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .padding(6)
                                .background(Circle().fill(.ultraThinMaterial))
                                .shadow(radius: 1)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 15)
            }
        }
        .frame(width: 340, height: 480)
    }
}

// Reusable Glass Card Component
struct GlassCard<Content: View>: View {
    var padding: CGFloat = 16
    var content: () -> Content
    
    init(padding: CGFloat = 16, @ViewBuilder content: @escaping () -> Content) {
        self.padding = padding
        self.content = content
    }
    
    var body: some View {
        content()
            .padding(padding)
            .background(.ultraThinMaterial)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.white.opacity(0.2), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
}

