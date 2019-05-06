import Cocoa
import EventKit

class EventMenuItemViewController: NSViewController {
    let event: EKEvent
    let menuItem: NSMenuItem
    
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
        view = NSView(frame: NSRect(x: 0, y: 0, width: 240, height: isMultiLine ? 33 : 19))
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        // Title
        let titleLabel = NSTextField(labelWithAttributedString: NSAttributedString(string: event.title, attributes: [:]))
        titleLabel.isEditable = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 21).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 20).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 2).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        var timeLabel: NSTextField?
        // Time
        if !event.isAllDay {
            timeLabel = NSTextField(labelWithAttributedString: NSAttributedString(string: event.startDate.time(), attributes: [
                .font: NSFont.systemFont(ofSize: 11),
                .foregroundColor: NSColor.secondaryLabelColor
            ]))
            timeLabel!.isEditable = false
            timeLabel!.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(timeLabel!)
            timeLabel!.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
            timeLabel!.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
            timeLabel!.heightAnchor.constraint(equalToConstant: 14).isActive = true
        }
        
        let secondaryAttributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 11),
            .foregroundColor: NSColor.secondaryLabelColor
        ]
        
        // Separator
        var separator: NSTextField?
        if !event.isAllDay && event.location != nil {
            separator = NSTextField(labelWithAttributedString: NSAttributedString(string: "･", attributes: secondaryAttributes))
            separator!.isEditable = false
            separator!.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(separator!)
            separator!.leadingAnchor.constraint(equalTo: timeLabel!.trailingAnchor, constant: 2).isActive = true
            separator!.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        }
        
        // Location
        if let location = event.location {
            let locationLabel = NSTextField(labelWithAttributedString: NSAttributedString(string: location, attributes: secondaryAttributes))
            locationLabel.isEditable = false
            locationLabel.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(locationLabel)
            locationLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
            if let separator = separator {
                locationLabel.leadingAnchor.constraint(equalTo: separator.trailingAnchor, constant: 2).isActive = true
            } else {
                locationLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
            }
        }
    }
}
