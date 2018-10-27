import Cocoa
import SwiftMoment

let view1 = NSView(frame: NSRect(x: 0, y: 0, width: 50, height: 50))
view1.wantsLayer = true
view1.layer?.backgroundColor = NSColor.blue.cgColor

let view2 = NSView(frame: NSRect(x: 0, y: 0, width: 10, height: 10))
view2.wantsLayer = true
view2.layer?.backgroundColor = NSColor.black.cgColor

view1.addSubview(view2)
