//
//  Calendar.swift
//  GlanceCalendar
//
//  Created by Andrew Branch on 10/21/18.
//  Copyright © 2018 Wheream.io. All rights reserved.
//

import Cocoa
import SwiftMoment

public class CalendarGrid: NSObject {
    public func getWeeks(month: Int, year: Int) -> [[Moment]] {
        let monthMoment = moment([ "year": year, "month": month ])!
        let firstDayMoment = monthMoment.subtract((monthMoment.weekday - 1).days)
        let lastDayMoment = monthMoment.add(1.months).subtract(1.days)
        var weeks: [[Moment]] = []
        var last = false
        var w = 0
        while !last {
            var week: [Moment] = []
            for d in 0...6 {
                let day = firstDayMoment.add(w.weeks + d.days)
                week.append(day)
                last = last || day.isEqualTo(lastDayMoment)
            }
            weeks.append(week)
            if last {
                break
            }
            w += 1
        }
        return weeks
    }
}
