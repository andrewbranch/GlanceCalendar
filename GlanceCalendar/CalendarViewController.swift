//
//  CalendarViewController.swift
//  GlanceCalendar
//
//  Created by Andrew Branch on 10/21/18.
//  Copyright © 2018 Wheream.io. All rights reserved.
//

import Cocoa
import SwiftMoment

class CalendarViewController: NSViewController {
    let dayViewSize = 24
    let dayViewMargin = 4
    let calendar = CalendarGrid()
    
    @IBOutlet var insetView: NSView!
    @IBOutlet var monthLabel: NSTextField!
    var month = moment().month
    var year = moment().year
    var dayViewControllers: [CalendarDayViewController]?
    private lazy var weeks: [[Moment]] = {
        return calendar.getWeeks(month: month, year: year)
    }()

    init() {
        super.init(nibName: "CalendarViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        insetView.heightAnchor.constraint(equalToConstant: CGFloat(weeks.count * (dayViewSize + dayViewMargin) - dayViewMargin)).isActive = true
        insetView.widthAnchor.constraint(equalToConstant: CGFloat(7 * (dayViewSize + dayViewMargin) - dayViewMargin)).isActive = true
        let widthConstraint = view.widthAnchor.constraint(equalTo: insetView.widthAnchor, constant: CGFloat(dayViewMargin * 2))
        widthConstraint.priority = .defaultHigh
        widthConstraint.isActive = true
        monthLabel.stringValue = weeks[1][0].monthName
        weeks.enumerated().forEach { week in
            week.element.enumerated().forEach { day in
                let vc = CalendarDayViewController(
                    frame: NSRect(
                        x: day.offset * (dayViewSize + dayViewMargin),
                        y: (weeks.count - 1 - week.offset) * (dayViewSize + dayViewMargin),
                        width: dayViewSize,
                        height: dayViewSize
                    ),
                    date: day.element,
                    forMonth: month
                )
                addChild(vc)
                insetView.addSubview(vc.view)
            }
        }
        // Without this (even with `view.needsLayout = true`), the view flashes in
        // at the wrong size before adjusting when the menu first opens.
        view.layoutSubtreeIfNeeded()
    }
    
    func setMonth(month: Int, year: Int) {
        self.month = month
        self.year = year
    }
}
