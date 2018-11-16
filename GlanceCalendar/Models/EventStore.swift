import Cocoa
import EventKit
import SwiftMoment

protocol EventStoreDelegate {
    func receivedAccessToEvents() -> Void
    func wasDeniedAccessToEvents() -> Void
    func receivedErrorRequestingAccessToEvents(error: Error) -> Void
}

class EventStore: NSObject {
    private let backingStore = EKEventStore()
    public var delegate: EventStoreDelegate
    
    public var hasAccessToEvents: Bool {
        get {
            return EKEventStore.authorizationStatus(for: .event) == .authorized
        }
    }
    
    init(delegate: EventStoreDelegate) {
        self.delegate = delegate
    }
    
    public func requestAccessToEvents() {
        backingStore.requestAccess(to: .event) { [weak self] (isAuthorized, error) in
            if let error = error {
                self?.delegate.receivedErrorRequestingAccessToEvents(error: error)
            } else if isAuthorized {
                self?.delegate.receivedAccessToEvents()
            } else {
                self?.delegate.wasDeniedAccessToEvents()
            }
        }
    }
    
    public func getEventsForDay(endingAfter: Moment, in calendars: [EKCalendar]? = nil) -> [EKEvent] {
        let calendars = calendars ?? backingStore.calendars(for: .event)
        let eod = moment([endingAfter.year, endingAfter.month, endingAfter.day + 1, 0, 0, -1])!
        let predicate = backingStore.predicateForEvents(withStart: endingAfter.date, end: eod.date, calendars: calendars)
        return backingStore.events(matching: predicate)
    }
}
