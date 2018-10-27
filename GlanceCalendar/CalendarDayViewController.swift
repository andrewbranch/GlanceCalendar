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
    private let label: NSTextField
    private let date: Moment
    private let forMonth: Int
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
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        if isToday {
            view.wantsLayer = true
            view.layer?.backgroundColor = NSColor(red: 0.75, green: 0.25, blue: 0.18, alpha: 0.8).cgColor
            view.layer?.cornerRadius = view.frame.width / 2
            label.textColor = NSColor.white
        }
        if !isInMonth {
            label.textColor = label.textColor!.withAlphaComponent(0.2)
        }
    }
    
    init(frame: NSRect, date: Moment, forMonth: Int) {
        self.date = date
        self.forMonth = forMonth
        self.frame = frame
        label = NSTextField(labelWithString: "\(date.day)")
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        view = NSView(frame: frame)
        view.addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
