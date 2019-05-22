//
//  CustomMenuItemView.swift
//  GlanceCalendar
//
//  Created by Andrew Branch on 5/21/19.
//  Copyright © 2019 Wheream.io. All rights reserved.
//

import Cocoa

class CustomMenuItemView: NSView {
    private var effectView: NSVisualEffectView

    override init(frame: NSRect) {
        effectView = NSVisualEffectView()
        effectView.state = .active
        effectView.material = .selection
        effectView.isEmphasized = true
        effectView.blendingMode = .behindWindow

        super.init(frame: frame)
        addSubview(effectView)
        effectView.frame = bounds
    }

    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ dirtyRect: NSRect) {
        effectView.isHidden = !(enclosingMenuItem?.isHighlighted ?? false)
    }
}
