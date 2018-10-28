//
//  CalendarDayViewController.swift
//  GlanceCalendar
//
//  Created by Andrew Branch on 10/21/18.
//  Copyright © 2018 Wheream.io. All rights reserved.
//

import Cocoa
import SwiftMoment

class CalendarDayViewController: NSViewController {
    static let margin = (8, 4)
    private let frame: NSRect
    private let date: Moment
    private let forMonth: Int
    private var label: NSTextField!
    private var background: NSView
    private var isToday: Bool {
        get {
            return Calendar.current.isDateInToday(date.date)
        }
    }
    private var isInMonth: Bool {
        get {
            return date.month == forMonth
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if isToday {
            background.layer?.opacity = 1
            label.textColor = NSColor.primaryTextInvert
        } else if !isInMonth {
            label.textColor = NSColor.disabledText
        } else {
            label.textColor = NSColor.primaryText
        }
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    init(frame: NSRect, date: Moment, forMonth: Int) {
        self.date = date
        self.forMonth = forMonth
        self.frame = frame
        background = NSView(frame: frame)
        background.layer = CALayer()
        background.wantsLayer = true
        background.layer?.backgroundColor = NSColor.accent.cgColor
        background.layer?.cornerRadius = frame.width / 2
        background.layer?.opacity = 0
        super.init(nibName: nil, bundle: nil)
        label = NSTextField(labelWithAttributedString: NSAttributedString(string: "\(date.day)", attributes: [
            .kern: -0.15
        ]))
        view.wantsLayer = true
    }
    
    override func loadView() {
        view = NSView(frame: frame)
        view.addSubview(background)
        view.addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
