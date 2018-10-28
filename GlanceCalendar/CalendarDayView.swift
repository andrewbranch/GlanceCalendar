//
//  CalendarDayView.swift
//  GlanceCalendar
//
//  Created by Andrew Branch on 10/28/18.
//  Copyright © 2018 Wheream.io. All rights reserved.
//

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
        wantsLayer = true
        layer?.cornerRadius = frame.width / 2
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
            label.textColor = NSColor.primaryTextInvert
            layer?.backgroundColor = NSColor.accent.cgColor
            break
        case .OutOfMonth:
            label.textColor = NSColor.disabledText
            layer?.backgroundColor = CGColor.clear
            break
        default:
            label.textColor = NSColor.primaryText
            layer?.backgroundColor = CGColor.clear
        }
    }
}
