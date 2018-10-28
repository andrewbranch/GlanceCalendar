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
    private var dayViewState: DayViewState {
        get {
            if isToday {
                return .Selected
            }
            if isInMonth {
                return .Default
            }
            return .OutOfMonth
        }
    }
    
    init(frame: NSRect, date: Moment, forMonth: Int) {
        self.date = date
        self.forMonth = forMonth
        self.frame = frame
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        view = CalendarDayView(string: "\(date.day)", state: dayViewState, frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
