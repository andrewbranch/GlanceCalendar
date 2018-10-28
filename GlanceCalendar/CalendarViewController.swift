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
    let dayViewSize: CGFloat = 24
    let dayViewMargin: CGFloat = 4
    let controlButtonMargin: CGFloat = 5
    let calendar = CalendarGrid()
    
    @IBOutlet var insetView: NSView!
    @IBOutlet var headerView: CalendarHeaderView!
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
        insetView.heightAnchor.constraint(equalToConstant: CGFloat(weeks.count) * (dayViewSize + dayViewMargin) - dayViewMargin).isActive = true
        insetView.widthAnchor.constraint(equalToConstant: 7 * (dayViewSize + dayViewMargin) - dayViewMargin).isActive = true
        let widthConstraint = view.widthAnchor.constraint(equalTo: insetView.widthAnchor, constant: dayViewMargin * 2)
        widthConstraint.priority = .defaultHigh
        widthConstraint.isActive = true
        
        monthLabel.stringValue = weeks[1][0].monthName
        let monthControlsContainer = NSView()
        let prevButton = MonthControlButton(imageName: "arrowLeft")
        let todayButton = MonthControlButton(imageName: "dot")
        let nextButton = MonthControlButton(imageName: "arrowRight")
        monthControlsContainer.translatesAutoresizingMaskIntoConstraints = false
        monthControlsContainer.subviews = [prevButton, todayButton, nextButton]
        headerView.addSubview(monthControlsContainer)
        nextButton.trailingAnchor.constraint(equalTo: monthControlsContainer.trailingAnchor).isActive = true
        todayButton.trailingAnchor.constraint(equalTo: nextButton.leadingAnchor, constant: -controlButtonMargin).isActive = true
        prevButton.trailingAnchor.constraint(equalTo: todayButton.leadingAnchor, constant: -controlButtonMargin).isActive = true
        monthControlsContainer.subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.centerYAnchor.constraint(equalTo: monthControlsContainer.centerYAnchor).isActive = true
        }
        monthControlsContainer.heightAnchor.constraint(equalTo: headerView.heightAnchor).isActive = true
        monthControlsContainer.widthAnchor.constraint(equalToConstant: prevButton.frame.width + nextButton.frame.width + todayButton.frame.width + 2 * controlButtonMargin).isActive = true
        monthControlsContainer.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        monthControlsContainer.trailingAnchor.constraint(equalTo: headerView.trailingAnchor).isActive = true
        
        weeks.enumerated().forEach { week in
            week.element.enumerated().forEach { day in
                let vc = CalendarDayViewController(
                    frame: NSRect(
                        x: CGFloat(day.offset) * (dayViewSize + dayViewMargin),
                        y: CGFloat(weeks.count - 1 - week.offset) * (dayViewSize + dayViewMargin),
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
