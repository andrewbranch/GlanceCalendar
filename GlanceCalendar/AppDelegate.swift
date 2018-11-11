import Cocoa
import ServiceManagement
import SwiftMoment
import Carbon

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    let launcherAppId = "com.wheream.io.GlanceCalendarLauncher"
    var menuController: MenuController?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Kick off all the things
        menuController = MenuController()

        scheduleLauncher()
        killLauncher()
    }
    
    private func scheduleLauncher() {
        if SMLoginItemSetEnabled(launcherAppId as CFString, true) {
            NSLog("Successfully scheduled launcher to run on login")
        }
    }
    
    private func killLauncher() {
        let runningApps = NSWorkspace.shared.runningApplications
        let launcherIsRunning = runningApps.contains { $0.bundleIdentifier == launcherAppId }
        if launcherIsRunning {
            DistributedNotificationCenter.default().post(
                name: .killLauncher,
                object: Bundle.main.bundleIdentifier!
            )
        }
    }
}

