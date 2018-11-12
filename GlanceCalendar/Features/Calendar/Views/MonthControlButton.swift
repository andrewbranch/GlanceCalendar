import Cocoa

class MonthControlButtonCell: NSButtonCell {
    override func highlight(_ flag: Bool, withFrame cellFrame: NSRect, in controlView: NSView) {
        if flag {
            controlView.layer?.backgroundColor = NSColor.controlBackgroundColor.withSystemEffect(.pressed).cgColor
        } else {
            controlView.layer?.backgroundColor = NSColor.clear.cgColor
        }
    }
}

class MonthControlButton: NSButton {
    init(imageName: NSImage.Name, target: AnyObject, action: Selector) {
        let image = NSImage(named: imageName)!
        let size = image.representations[0].size
        super.init(frame: NSRect(origin: CGPoint.zero, size: NSSize(width: size.width + 8, height: size.height)))
        cell = MonthControlButtonCell(imageCell: image)
        self.target = target
        self.action = action
        wantsLayer = true
        layer?.cornerRadius = 2
        isBordered = false
        widthAnchor.constraint(equalToConstant: size.width + 8).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
