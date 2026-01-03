import Foundation

class HapticEngine {
    static let shared = HapticEngine()
    
    // AppleScript command to trigger the shortcut
    // New: Cmd+Ctrl+Opt+Shift+U (to avoid Finder 'Utilities' conflict)
    private let triggerScript = """
    tell application "System Events"
        key code 32 using {command down, shift down, control down, option down}
    end tell
    """
    
    func playPattern(_ pattern: String) {
        print("Playing pattern: \(pattern)")
        
        Task {
            switch pattern {
            case "double":
                trigger(); try? await Task.sleep(nanoseconds: 150 * 1_000_000); trigger()
            case "pulse":
                trigger(); try? await Task.sleep(nanoseconds: 75 * 1_000_000); trigger(); try? await Task.sleep(nanoseconds: 75 * 1_000_000); trigger()
            case "heartbeat":
                trigger(); try? await Task.sleep(nanoseconds: 120 * 1_000_000); trigger()
            case "triple":
                // Slower, longer triple (250ms gaps)
                trigger(); try? await Task.sleep(nanoseconds: 250 * 1_000_000); trigger(); try? await Task.sleep(nanoseconds: 250 * 1_000_000); trigger()
            case "gallop":
                trigger(); try? await Task.sleep(nanoseconds: 80 * 1_000_000); trigger(); try? await Task.sleep(nanoseconds: 200 * 1_000_000); trigger()
            case "single":
                trigger()
            
            // --- NEW PATTERNS ---
            case "long": // Simulates a buzz by rapid firing
                for _ in 0..<15 {
                    trigger()
                    try? await Task.sleep(nanoseconds: 30 * 1_000_000)
                }
            case "sos": // ... --- ...
                for _ in 0..<3 { trigger(); try? await Task.sleep(nanoseconds: 100 * 1_000_000) } // S
                try? await Task.sleep(nanoseconds: 200 * 1_000_000)
                for _ in 0..<3 { trigger(); try? await Task.sleep(nanoseconds: 300 * 1_000_000) } // O
                try? await Task.sleep(nanoseconds: 200 * 1_000_000)
                for _ in 0..<3 { trigger(); try? await Task.sleep(nanoseconds: 100 * 1_000_000) } // S
            case "engine_start": // Revving up
                trigger(); try? await Task.sleep(nanoseconds: 200 * 1_000_000)
                trigger(); try? await Task.sleep(nanoseconds: 150 * 1_000_000)
                trigger(); try? await Task.sleep(nanoseconds: 100 * 1_000_000)
                trigger(); try? await Task.sleep(nanoseconds: 80 * 1_000_000)
                trigger(); try? await Task.sleep(nanoseconds: 60 * 1_000_000)
                trigger(); try? await Task.sleep(nanoseconds: 50 * 1_000_000)
                trigger()
            case "blaster": // Fast burst
                for _ in 0..<6 {
                    trigger()
                    try? await Task.sleep(nanoseconds: 40 * 1_000_000)
                }
            
            default:
                trigger()
            }
        }
    }
    
    private func trigger() {
        // Execute AppleScript
        var error: NSDictionary?
        if let scriptObject = NSAppleScript(source: triggerScript) {
            scriptObject.executeAndReturnError(&error)
            if let error = error {
                print("AppleScript Error: \(error)")
            }
        }
    }
}
