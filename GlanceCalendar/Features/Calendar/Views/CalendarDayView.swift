import Cocoa

enum DayViewState {
    case normal
    case selected
    case today
    case outOfMonth
}

class CalendarDayView: NSButton {
    private let label: String
    override var allowsVibrancy: Bool {
        get {
            return viewState != .selected
        }
    }
    private var buttonCell: NSButtonCell {
        get {
            return cell! as! NSButtonCell
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
        buttonCell.highlightsBy = .contentsCellMask
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
        case .today:
            wantsLayer = true
            layer?.cornerRadius = frame.width / 2
            layer?.backgroundColor = NSColor.highlightBackground.cgColor
            attributedTitle = getStringWithColor(string: label, color: .highlightForeground)
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
