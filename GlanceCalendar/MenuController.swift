import Cocoa
import EventKit
import SwiftMoment

class MenuController: NSObject, NSMenuDelegate, CalendarViewDelegate, EventStoreDelegate {
    let menu = NSMenu()
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    let dateTimeSettingsURL = URL(fileURLWithPath: "/System/Library/PreferencePanes/DateAndTime.prefPane")
    let dateMenuItem = NSMenuItem(title: Date.fullDate(), action: nil, keyEquivalent: "")
    let eventItemSeperator = NSMenuItem.separator()
    var eventStore: EventStore!
    var calendarViewController: CalendarViewController!
    var highlightTitle: NSMutableAttributedString?
    var title: NSMutableAttributedString?
    var menuIsOpen = false
    var events: [EKEvent] = []
    var eventItems: [NSMenuItem] = [] {
        didSet {
            oldValue.forEach { menu.removeItem($0) }
            if eventItems.count > 0 && oldValue.count == 0 {
                menu.insertItem(eventItemSeperator, at: 4)
            } else if eventItems.count == 0 && oldValue.count > 0 {
                menu.removeItem(eventItemSeperator)
            }

            eventItems.enumerated().forEach { menu.insertItem($0.element, at: 4 + $0.offset) }
        }
    }
    var selectedTime: Moment {
        didSet {
            calendarViewController.updateCalendar(currentTime: Clock.shared.currentTick, selectedTime: selectedTime)
            if eventStore.hasAccessToEvents {
                updateEventItems()
            }
        }
    }

    override init() {
        let now = Clock.shared.currentTick
        selectedTime = now
        
        super.init()
        calendarViewController = CalendarViewController(delegate: self)
        highlightTitle = NSMutableAttributedString(string: Date.dayOfWeekAndTime(), attributes: [
            .foregroundColor: NSColor.white,
            // Default system clock uses a light weight when highlighted
            .font: NSFont.systemFont(ofSize: statusItem.button!.cell?.font?.pointSize ?? 14, weight: .light),
            .baselineOffset: -1
        ])
        title = NSMutableAttributedString(string: Date.dayOfWeekAndTime(), attributes: [
            .baselineOffset: -1
        ])
        
        statusItem.button!.attributedTitle = title!
        statusItem.button!.attributedAlternateTitle = highlightTitle!
        
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
        
        Clock.shared.onChange(quantum: .minute) { [weak self] time in
            DispatchQueue.main.async {
                self?.updateTimeAndDateViews(time: time)
                self?.calendarViewController.updateCalendar(currentTime: time, selectedTime: self!.selectedTime)
            }
        }
        
        eventStore = EventStore(delegate: self)
        eventStore.requestAccessToEvents()
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
    
    @objc func showAllEvents() {
        eventItems = eventItems.dropLast() + events[4...].map { event in
            return NSMenuItem(title: event.title, action: nil, keyEquivalent: "")
        }
    }
    
    func updateEventItems() {
        let events = eventStore.getEventsForDay(endingAfter: selectedTime)
        self.events = events
        if events.count > 0 {
            eventItems = events[...min(events.count - 1, 3)].map { event in
                return NSMenuItem(title: event.title, action: nil, keyEquivalent: "")
            }
            
            if events.count > 4 {
                eventItems.append(NSMenuItem(title: "Show \(events.count - 4) more", action: #selector(self.showAllEvents), keyEquivalent: ""))
            }
        } else {
            eventItems = []
        }
    }
    
    func receivedAccessToEvents() {
        updateEventItems()
    }
    
    func wasDeniedAccessToEvents() {
        //
    }
    
    func receivedErrorRequestingAccessToEvents(error: Error) {
        //
    }
}

