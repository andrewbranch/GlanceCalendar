import Cocoa
import EventKit

class EventMenuItemViewController: NSViewController {
    let event: EKEvent
    let menuItem: NSMenuItem
    let design = DesignFacts.defaultDesign.events
    
    private var isMultiLine: Bool {
        get {
            return !event.isAllDay || event.location != nil
        }
    }

    init(event: EKEvent) {
        self.event = event
        menuItem = NSMenuItem(title: "", action: nil, keyEquivalent: "")
        menuItem.setAccessibilityLabel(event.title)
        super.init(nibName: nil, bundle: nil)
        menuItem.view = view
    }
    
    override func loadView() {
        let height = isMultiLine ? design.multiLineMenuItemHeight : design.singleLineMenuItemHeight
        view = NSView(frame: NSRect(x: 0, y: 0, width: 240, height: height))
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        let marginLeft = DesignFacts.defaultDesign.common.menuMarginLeft
        let marginRight = DesignFacts.defaultDesign.common.menuMarginRight
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byTruncatingTail
        let primaryAttributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 13),
            .paragraphStyle: paragraphStyle
        ]
        let secondaryAttributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 11),
            .foregroundColor: NSColor.secondaryLabelColor,
            .paragraphStyle: paragraphStyle
        ]

        // Title
        let titleLabel = NSTextField(labelWithAttributedString: NSAttributedString(string: event.title, attributes: primaryAttributes))
        titleLabel.isEditable = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: marginLeft).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -marginRight).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: design.menuItemLineMargin).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: design.primaryLabelHeight).isActive = true
        
        // Dot
        let dot = NSView()
        dot.translatesAutoresizingMaskIntoConstraints = false
        dot.wantsLayer = true
        dot.layer?.backgroundColor = event.calendar.color.cgColor
        dot.layer?.cornerRadius = design.dotSize / 2
        view.addSubview(dot)
        dot.widthAnchor.constraint(equalToConstant: design.dotSize).isActive = true
        dot.heightAnchor.constraint(equalToConstant: design.dotSize).isActive = true
        dot.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        dot.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: design.dotOffsetLeft).isActive = true
        
        // Time
        var timeLabel: NSTextField?
        if !event.isAllDay {
            timeLabel = NSTextField(labelWithAttributedString: NSAttributedString(string: event.startDate.time(), attributes: [
                .font: NSFont.systemFont(ofSize: 11),
                .foregroundColor: NSColor.secondaryLabelColor
            ]))
            timeLabel!.isEditable = false
            timeLabel!.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(timeLabel!)
            timeLabel!.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
            let widthConstraint = timeLabel!.widthAnchor.constraint(equalToConstant: 0)
            widthConstraint.priority = .defaultLow
            widthConstraint.isActive = true
            timeLabel!.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
            timeLabel!.heightAnchor.constraint(equalToConstant: design.secondaryLabelHeight).isActive = true
        }
        
        // Separator
        var separator: NSTextField?
        if !event.isAllDay && event.location != nil {
            separator = NSTextField(labelWithAttributedString: NSAttributedString(string: "･", attributes: secondaryAttributes))
            separator!.isEditable = false
            separator!.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(separator!)
            separator!.leadingAnchor.constraint(equalTo: timeLabel!.trailingAnchor, constant: design.menuItemBulletMargin).isActive = true
            separator!.heightAnchor.constraint(equalToConstant: design.secondaryLabelHeight).isActive = true
            separator!.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        }
        
        // Location
        if let location = event.location {
            let locationLabel = NSTextField(labelWithAttributedString: NSAttributedString(string: location, attributes: secondaryAttributes))
            locationLabel.isEditable = false
            locationLabel.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(locationLabel)
            locationLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
            locationLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -marginRight).isActive = true
            if let separator = separator {
                locationLabel.leadingAnchor.constraint(equalTo: separator.trailingAnchor, constant: design.menuItemBulletMargin).isActive = true
            } else {
                locationLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
            }
        }
    }
}
