import Cocoa

enum DayViewState {
    case Default
    case Selected
    case OutOfMonth
}

class CalendarDayView: NSView {
    private let label: NSTextField
    override var allowsVibrancy: Bool {
        get {
            return state != .Selected
        }
    }
    public var state: DayViewState {
        didSet {
            updateLayer()
        }
    }
    init(string: String, state: DayViewState, frame: NSRect) {
        self.state = state
        label = NSTextField(labelWithAttributedString: NSAttributedString(string: string, attributes: [
            .kern: -0.15
        ]))
        super.init(frame: frame)
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func updateLayer() {
        switch state {
        case .Selected:
            wantsLayer = true
            layer?.cornerRadius = frame.width / 2
            layer?.backgroundColor = NSColor.accent.cgColor
            label.textColor = NSColor.primaryTextInvert
            break
        case .OutOfMonth:
            wantsLayer = false
            label.textColor = NSColor.disabledText
            break
        default:
            wantsLayer = false
            label.textColor = NSColor.primaryText
        }
    }
}
