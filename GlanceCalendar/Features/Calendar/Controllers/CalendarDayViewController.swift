import Cocoa
import SwiftMoment

class CalendarDayViewController: NSViewController {
    static let margin = (8, 4)

    private let frame: NSRect
    private let onClick: () -> Void
    private var dayView: CalendarDayView {
        get {
            return view as! CalendarDayView
        }
    }
    private var dayViewState: DayViewState {
        get {
            if isSelected {
                return .selected
            }
            if isToday {
                return .selected
            }
            if inAdjacentMonth {
                return .outOfMonth
            }
            return .normal
        }
    }
    
    public let day: Int
    public let inAdjacentMonth: Bool
    public var isSelected: Bool = false {
        didSet {
            dayView.viewState = dayViewState
        }
    }
    public var isToday: Bool = false {
        didSet {
            dayView.viewState = dayViewState
        }
    }
    
    init(frame: NSRect, day: Int, isToday: Bool, inAdjacentMonth: Bool, onClick: @escaping () -> Void) {
        self.frame = frame
        self.day = day
        self.isToday = isToday
        self.inAdjacentMonth = inAdjacentMonth
        self.onClick = onClick
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        view = CalendarDayView(string: "\(day)", state: dayViewState, frame: frame, target: self, action: #selector(runClickCallback))
    }
    
    @objc private func runClickCallback() {
        onClick()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
