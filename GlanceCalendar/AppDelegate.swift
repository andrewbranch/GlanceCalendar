//
//  AppDelegate.swift
//  GlanceCalendar
//
//  Created by Andrew Branch on 10/21/18.
//  Copyright © 2018 Wheream.io. All rights reserved.
//

import Cocoa
import ServiceManagement

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSMenuDelegate {

    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    let dateTimeSettingsURL = URL(fileURLWithPath: "/System/Library/PreferencePanes/DateAndTime.prefPane")
    let calendarViewController = CalendarViewController()
    var highlightTitle: NSMutableAttributedString?
    var title: NSMutableAttributedString?
    var menuIsOpen = false

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let launcherAppId = "com.wheream.io.GlanceCalendarLauncher"
        let runningApps = NSWorkspace.shared.runningApplications
        let isRunning = runningApps.contains { $0.bundleIdentifier == launcherAppId }

        if SMLoginItemSetEnabled(launcherAppId as CFString, true) {
            NSLog("Successfully scheduled launcher to run on login")
        }
        
        if isRunning {
            DistributedNotificationCenter.default().post(
                name: .killLauncher,
                object: Bundle.main.bundleIdentifier!
            )
        }

        guard let button = statusItem.button else {
            return
        }
        highlightTitle = NSMutableAttributedString(string: Date.dayOfWeekAndTime(), attributes: [
            .foregroundColor: NSColor.white,
            .font: NSFont.systemFont(ofSize: button.cell?.font?.pointSize ?? 14, weight: .light),
            .baselineOffset: -1
        ])
        title = NSMutableAttributedString(string: Date.dayOfWeekAndTime(), attributes: [
            .baselineOffset: -1
        ])
        
        button.attributedTitle = title!
        // Default system clock uses a light weight when highlighted
        button.attributedAlternateTitle = highlightTitle!
        
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: Date.fullDate(), action: nil, keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        let calendarMenuItem = NSMenuItem()
        calendarMenuItem.view = calendarViewController.view
        
        menu.addItem(calendarMenuItem)
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Date & Time Preferences…", action: #selector(openDateTimeSettings), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        menu.delegate = self
        statusItem.menu = menu
        
        let timer = Timer(timeInterval: 1, repeats: true) { _ in
            self.updateTime()
        }
        RunLoop.main.add(timer, forMode: RunLoop.Mode.common)
    }
    
    @objc func openDateTimeSettings() {
        NSWorkspace.shared.open(dateTimeSettingsURL)
    }
    
    func updateTime() {
        let timeString = Date.dayOfWeekAndTime()
        title!.mutableString.setString(timeString)
        highlightTitle!.mutableString.setString(timeString)
        statusItem.button!.attributedTitle = title!
        if menuIsOpen {
            statusItem.button!.attributedAlternateTitle = highlightTitle!
        }
    }
    
    func menuWillOpen(_ menu: NSMenu) {
        menuIsOpen = true
        updateTime()
    }

    // After becoming unhighlighted, the text gets stuck kind of bold for some reason
    func menuDidClose(_ menu: NSMenu) {
        menuIsOpen = false
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(50)) { [weak self] in
            self?.statusItem.button?.setNeedsDisplay(self!.statusItem.button!.bounds)
        }
    }
}

