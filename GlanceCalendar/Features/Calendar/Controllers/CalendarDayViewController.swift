import Cocoa
import SwiftMoment

class CalendarDayViewController: NSViewController {
    static let margin = (8, 4)
    private let frame: NSRect
    public let date: Moment
    private let forMonth: Int
    private var dayView: CalendarDayView {
        get {
            return view as! CalendarDayView
        }
    }
    public var isSelected: Bool = false {
        didSet {
            dayView.state = dayViewState
        }
    }
    private var isToday: Bool {
        get {
            return Calendar.current.isDate(date.date, inSameDayAs: Clock.shared.currentTick)
        }
    }
    private var isInMonth: Bool {
        get {
            return date.month == forMonth
        }
    }
    private var dayViewState: DayViewState {
        get {
            if isSelected {
                return .Selected
            }
            if isInMonth {
                return .Default
            }
            return .OutOfMonth
        }
    }
    
    init(frame: NSRect, date: Moment, forMonth: Int) {
        self.date = date
        self.forMonth = forMonth
        self.frame = frame
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        view = CalendarDayView(string: "\(date.day)", state: dayViewState, frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
