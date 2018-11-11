import Cocoa

enum DayViewState {
    case normal
    case selected
    case outOfMonth
}

class CalendarDayView: NSButton {
    private let label: String
    override var allowsVibrancy: Bool {
        get {
            return viewState != .selected
        }
    }
    public var viewState: DayViewState {
        didSet {
            refreshAppearance()
        }
    }
    init(string: String, state: DayViewState, frame: NSRect, target: AnyObject, action: Selector) {
        label = string
        viewState = state
        super.init(frame: frame)
        
        isBordered = false
        self.target = target
        self.action = action
    }
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func refreshAppearance() {
        switch viewState {
        case .selected:
            wantsLayer = true
            layer?.cornerRadius = frame.width / 2
            layer?.backgroundColor = NSColor.accent.cgColor
            attributedTitle = getStringWithColor(string: label, color: .primaryTextInvert)
            break
        case .outOfMonth:
            wantsLayer = false
            attributedTitle = getStringWithColor(string: label, color: .disabledText)
            break
        default:
            wantsLayer = false
            attributedTitle = getStringWithColor(string: label, color: .primaryText)
        }
    }
    
    private func getStringWithColor(string: String, color: NSColor) -> NSAttributedString {
        return NSAttributedString(string: string, attributes: [
            .kern: -0.15,
            .foregroundColor: color
        ])
    }
}
