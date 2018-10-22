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
    static let margin = 8
    @IBOutlet var label: NSTextField!
    private var date: Moment
    override func viewDidLoad() {
        super.viewDidLoad()
        label.stringValue = "\(date.day)"
    }
    
    init(x: Int, y: Int, date: Moment) {
        self.date = date
        super.init(nibName: "CalendarDayViewController", bundle: nil)
        let viewSize = self.view.frame.width
        view.frame.origin = CGPoint(
            x: x * (Int(viewSize) + CalendarDayViewController.margin),
            y: (5 - y) * (Int(viewSize) + CalendarDayViewController.margin)
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
