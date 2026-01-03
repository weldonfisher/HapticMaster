import SwiftUI

@main
struct HapticMasterApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        MenuBarExtra("Haptic Master", systemImage: "magicmouse.fill") {
            ContentView()
        }
        .menuBarExtraStyle(.window)
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        WebServer.shared.start()
        NotificationWatcher.shared.start()
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        WebServer.shared.stop()
    }
}
