//
//  AppDelegate.swift
//  GlanceCalendar
//
//  Created by Andrew Branch on 10/21/18.
//  Copyright © 2018 Wheream.io. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSMenuDelegate {

    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    let dateTimeSettingsURL = URL(fileURLWithPath: "/System/Library/PreferencePanes/DateAndTime.prefPane")
    let calendarViewController = CalendarViewController()
    var highlightTitle: NSMutableAttributedString?
    var menuIsOpen = false

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        guard let button = statusItem.button else {
            return
        }
        highlightTitle = NSMutableAttributedString(string: Date.dayOfWeekAndTime(), attributes: [
            .foregroundColor: NSColor.white,
            .font: NSFont.systemFont(ofSize: button.cell?.font?.pointSize ?? 14, weight: .light)
        ])
        button.title = Date.dayOfWeekAndTime()
        
        // Default system clock uses a light weight when highlighted
        button.attributedAlternateTitle = self.highlightTitle!
        
        // Bizarrely, the default frame puts the text 1px higher than the system clock
        button.frame.size.height -= 1
        
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: Date.fullDate(), action: nil, keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        let calendarMenuItem = NSMenuItem()
        calendarMenuItem.view = calendarViewController.view
        menu.addItem(calendarMenuItem)
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Open Date & Time Preferences…", action: #selector(openDateTimeSettings), keyEquivalent: ""))
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
        statusItem.button!.title = timeString
        highlightTitle!.mutableString.setString(timeString)
        if menuIsOpen {
            statusItem.button!.attributedAlternateTitle = highlightTitle!
        }
    }
    
    func menuWillOpen(_ menu: NSMenu) {
        calendarViewController.view.frame.size.width = menu.size.width
        menuIsOpen = true
        updateTime()
    }

    // After becoming unhighlighted, the text gets stuck kind of bold for some reason
    func menuDidClose(_ menu: NSMenu) {
        menuIsOpen = false
        DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
            self?.statusItem.button?.setNeedsDisplay(self!.statusItem.button!.bounds)
        }
    }
}

