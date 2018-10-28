import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        NSLog("GlanceLauncher started...")
        let mainAppIdentifier = "com.wheream.io.GlanceCalendar"
        let runningApps = NSWorkspace.shared.runningApplications
        let isRunning = runningApps.contains { $0.bundleIdentifier == mainAppIdentifier }
        
        if !isRunning {
            NSLog("Glance is not running. Will attempt to start.")
            DistributedNotificationCenter.default().addObserver(
                self,
                selector: #selector(self.terminate),
                name: .killLauncher,
                object: mainAppIdentifier
            )
            
            let path = Bundle.main.bundlePath as NSString
            var components = path.pathComponents
            components.removeLast(4)
            let newPath = NSString.path(withComponents: components)
            
            NSWorkspace.shared.launchApplication(newPath)
            NSLog("Started GlanceCalendar")
        }
        else {
            self.terminate()
        }
    }
    
    @objc private func terminate() {
        NSLog("Quitting Launcher")
        NSApp.terminate(nil)
    }
}
