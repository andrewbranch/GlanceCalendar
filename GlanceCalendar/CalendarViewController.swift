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
    let calendar = CalendarGrid()
    
    @IBOutlet var insetView: NSView!
    var month = moment().month
    var year = moment().year
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
        getDayViewControllers().forEach {
            self.insetView.addSubview($0.view)
        }
    }
    
    func setMonth(month: Int, year: Int) {
        self.month = month
        self.year = year
    }
    
    func getDayViewControllers() -> [CalendarDayViewController] {
        return weeks.enumerated().flatMap { (i, week) in
            return week.enumerated().map { (j, day) in
                return CalendarDayViewController(x: j, y: i, date: day)
            }
        }
    }
}
