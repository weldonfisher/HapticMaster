import SwiftUI

@main
struct HapticMasterApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        // .windowStyle(.hiddenTitleBar) // Optional: strict glass look but standard title bar is safer for now
        .windowResizability(.contentSize)
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
