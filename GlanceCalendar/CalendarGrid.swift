//
//  Calendar.swift
//  GlanceCalendar
//
//  Created by Andrew Branch on 10/21/18.
//  Copyright © 2018 Wheream.io. All rights reserved.
//

import Cocoa
import SwiftMoment

class CalendarGrid: NSObject {
    func getWeeks(month: Int, year: Int) -> [[Date]] {
        let monthMoment = moment([ "year": year, "month": month ])!
        let firstDayMoment = monthMoment.subtract((monthMoment.weekday - 1).days)
        let lastDayMoment = monthMoment.add(1.months).subtract(1.days)
        var weeks: [[Date]] = []
        var last = false
        var w = 0
        while !last {
            var week: [Date] = []
            for d in 0...6 {
                let day = firstDayMoment.add(w.weeks + d.days)
                week.append(day.date)
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
