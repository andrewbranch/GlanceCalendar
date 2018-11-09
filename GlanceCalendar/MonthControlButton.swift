//
//  MonthControlButton.swift
//  GlanceCalendar
//
//  Created by Andrew Branch on 10/28/18.
//  Copyright © 2018 Wheream.io. All rights reserved.
//

import Cocoa

class MonthControlButton: NSButton {
    init(imageName: NSImage.Name, target: AnyObject, action: Selector) {
        let image = NSImage(named: imageName)!
        let size = image.representations[0].size
        super.init(frame: NSRect(origin: CGPoint.zero, size: size))
        self.image = image
        self.target = target
        self.action = action
        isBordered = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
