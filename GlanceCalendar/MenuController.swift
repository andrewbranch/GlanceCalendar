import Cocoa
import SwiftMoment

class MenuController: NSObject, NSMenuDelegate, CalendarViewDelegate {
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    let dateTimeSettingsURL = URL(fileURLWithPath: "/System/Library/PreferencePanes/DateAndTime.prefPane")
    let dateMenuItem = NSMenuItem(title: Date.fullDate(), action: nil, keyEquivalent: "")
    var calendarViewController: CalendarViewController!
    var highlightTitle: NSMutableAttributedString?
    var title: NSMutableAttributedString?
    var menuIsOpen = false
    var selectedTime: Moment {
        didSet {
            calendarViewController.updateCalendar(currentTime: Clock.shared.currentTick, selectedTime: selectedTime)
        }
    }

    override init() {
        let now = Clock.shared.currentTick
        selectedTime = now
        
        super.init()
        calendarViewController = CalendarViewController(delegate: self, currentTime: now)
        guard let button = statusItem.button else {
            fatalError()
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
        menu.addItem(dateMenuItem)
        menu.addItem(NSMenuItem.separator())
        let calendarMenuItem = NSMenuItem()
        calendarMenuItem.view = calendarViewController.view
        
        menu.addItem(calendarMenuItem)
        menu.addItem(NSMenuItem.separator())
        let prefsMenuItem = NSMenuItem(title: "Date & Time Preferences…", action: #selector(openDateTimeSettings), keyEquivalent: "")
        prefsMenuItem.target = self
        menu.addItem(prefsMenuItem)
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        menu.delegate = self
        statusItem.menu = menu
        
        CarbonKeyHandler.shared.addHandler(forSpecialKey: .leftArrow) { [weak self] in self?.calendarViewController.goToPreviousMonth() }
        CarbonKeyHandler.shared.addHandler(forSpecialKey: .rightArrow) { [weak self] in self?.calendarViewController.goToNextMonth() }
        
        Clock.shared.onChange(quantum: .minute) { [weak self] time in
            DispatchQueue.main.async {
                self?.updateTimeAndDateViews(time: time)
                self?.calendarViewController.updateCalendar(currentTime: time, selectedTime: self!.selectedTime)
            }
        }
    }
    
    @objc func openDateTimeSettings() {
        NSWorkspace.shared.open(dateTimeSettingsURL)
    }
    
    func updateTimeAndDateViews(time: Moment = Clock.shared.currentTick) {
        let timeString = Date.dayOfWeekAndTime()
        title!.mutableString.setString(timeString)
        highlightTitle!.mutableString.setString(timeString)
        statusItem.button!.attributedTitle = title!
        dateMenuItem.title = Date.fullDate()
        if menuIsOpen {
            statusItem.button!.attributedAlternateTitle = highlightTitle!
        }
    }
    
    func menuWillOpen(_ menu: NSMenu) {
        menuIsOpen = true
        updateTimeAndDateViews()
    }
    
    // After becoming unhighlighted, the text gets stuck kind of bold for some reason
    func menuDidClose(_ menu: NSMenu) {
        menuIsOpen = false
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(50)) { [weak self] in
            self?.statusItem.button?.setNeedsDisplay(self!.statusItem.button!.bounds)
        }
    }
    
    func calendarViewController(viewController: CalendarViewController, didRequestSelectedTime time: Moment) {
        selectedTime = time
    }
    
    func calendarViewController(viewController: CalendarViewController, didRequestMonthChange addMonths: Int) {
        let now = Clock.shared.currentTick
        let newMonth = moment([selectedTime.year, selectedTime.month + addMonths])!
        let isCurrentMonth = newMonth.isSameMonth(now)
        let newTime = isCurrentMonth ? moment([newMonth.year, newMonth.month, now.day])! : newMonth
        selectedTime = newTime
    }
    
    func calendarViewControllerDidRequestSelectedTimeToNow(viewController: CalendarViewController) {
        selectedTime = Clock.shared.currentTick
    }
}

