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
    
    var calendarHeightConstraint: NSLayoutConstraint?
    var dayViewControllers: [CalendarDayViewController] = []
    @IBOutlet var insetView: NSView!
    @IBOutlet var headerView: CalendarHeaderView!
    @IBOutlet var monthLabel: NSTextField!
    public var currentDate = moment()
    private var selectedDate = moment() {
        didSet {
            if !oldValue.isSameMonth(selectedDate) {
                updateCalendar()
            } else if oldValue.day != selectedDate.day {
                updateSelectedDay(prevDay: oldValue, nextDay: selectedDate)
            }
        }
    }

    private var weeks: [[Moment]] {
        get {
            return calendar.getWeeks(month: selectedDate.month, year: selectedDate.year)
        }
    }
    
    private var calendarHeight: CGFloat {
        get {
            return CGFloat(weeks.count) * (dayViewSize + dayViewMargin) - dayViewMargin
        }
    }

    init() {
        super.init(nibName: "CalendarViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarHeightConstraint = insetView.heightAnchor.constraint(equalToConstant: calendarHeight)
        calendarHeightConstraint!.isActive = true
        insetView.widthAnchor.constraint(equalToConstant: 7 * (dayViewSize + dayViewMargin) - dayViewMargin).isActive = true
        let widthConstraint = view.widthAnchor.constraint(equalTo: insetView.widthAnchor, constant: dayViewMargin * 2)
        widthConstraint.priority = .defaultHigh
        widthConstraint.isActive = true
        
        
        let monthControlsContainer = NSView()
        let prevButton = MonthControlButton(imageName: "arrowLeft", target: self, action: #selector(self.goToPreviousMonth))
        let todayButton = MonthControlButton(imageName: "dot", target: self, action: #selector(self.goToToday))
        let nextButton = MonthControlButton(imageName: "arrowRight", target: self, action: #selector(self.goToNextMonth))
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

        updateCalendar()
    }
    
    func setMonth(month: Int, year: Int) {
        let isCurrentMonth = (year, month) == (currentDate.year, currentDate.month)
        selectedDate = moment([year, month, isCurrentMonth ? currentDate.day : 1])!
    }
    
    @objc func goToToday() {
        selectedDate = moment()
    }
    
    @objc func goToPreviousMonth() {
        setMonth(month: selectedDate.month - 1, year: selectedDate.year)
    }
    
    @objc func goToNextMonth() {
        setMonth(month: selectedDate.month + 1, year: selectedDate.year)
    }
    
    func updateCalendar() {
        dayViewControllers.forEach {
            $0.view.viewWillMove(toSuperview: nil)
            $0.view.removeFromSuperview()
            $0.removeFromParent()
        }

        dayViewControllers = []
        monthLabel.stringValue = weeks[1][0].monthName
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
                    forMonth: selectedDate.month
                )
                vc.isSelected = day.element.isSameDay(selectedDate)
                addChild(vc)
                insetView.addSubview(vc.view)
                dayViewControllers.append(vc)
            }
        }

        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.1
            calendarHeightConstraint!.animator().constant = calendarHeight
        }
        // Without this (even with `view.needsLayout = true`), the view flashes in
        // at the wrong size before adjusting when the menu first opens.
        view.layoutSubtreeIfNeeded()
    }
    
    func getDayViewController(forDay day: Int) -> CalendarDayViewController {
        let offset = dayViewControllers.firstIndex { $0.date.day == day }!
        return dayViewControllers[day - 1 + offset]
    }
    
    func updateSelectedDay(prevDay: Moment, nextDay: Moment) {
        getDayViewController(forDay: prevDay.day).isSelected = false
        getDayViewController(forDay: nextDay.day).isSelected = true
    }
}
