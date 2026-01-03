import Cocoa
import ApplicationServices

class NotificationWatcher {
    static let shared = NotificationWatcher()
    private var observer: AXObserver?
    
    func start() {
        DispatchQueue.global().async {
            self.setupObserver()
        }
    }
    
    private func setupObserver() {
        let workspace = NSWorkspace.shared
        guard let app = workspace.runningApplications.first(where: { $0.bundleIdentifier == "com.apple.notificationcenterui" }) else {
            print("Notification Center not running")
            return
        }
        
        let pid = app.processIdentifier
        var observer: AXObserver?
        
        let result = AXObserverCreate(pid, { (observer, element, notification, refcon) in
            // Check Master Toggle
            if UserDefaults.standard.bool(forKey: "systemNotificationsEnabled") == false {
                return
            }
            
            print("Notification Detected!")
            let pattern = UserDefaults.standard.string(forKey: "notificationPattern") ?? "pulse"
            if pattern != "none" {
                HapticEngine.shared.playPattern(pattern)
            }
        }, &observer)
        
        guard result == .success, let axObserver = observer else { return }
        self.observer = axObserver
        
        let notificationStr = kAXWindowCreatedNotification as CFString
        let axElement = AXUIElementCreateApplication(pid)
        
        AXObserverAddNotification(axObserver, axElement, notificationStr, nil)
        CFRunLoopAddSource(CFRunLoopGetCurrent(), AXObserverGetRunLoopSource(axObserver), .defaultMode)
        
        print("Listening for Notifications on PID \(pid)...")
        CFRunLoopRun()
    }
}
