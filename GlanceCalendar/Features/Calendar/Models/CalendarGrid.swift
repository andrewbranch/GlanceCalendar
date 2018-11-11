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
                let day = moment([
                    "year": firstDayMoment.year,
                    "month": firstDayMoment.month,
                    "day": firstDayMoment.day + 7 * w + d
                ])!
                week.append(day)
                last = last || (day.day == lastDayMoment.day && day.month == lastDayMoment.month)
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
