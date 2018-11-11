import SwiftMoment

extension Moment {
    func isSameMonth(_ moment: Moment) -> Bool {
        return (year, month) == (moment.year, moment.month)
    }
    func isSameDay(_ moment: Moment) -> Bool {
        return (year, month, day) == (moment.year, moment.month, moment.day)
    }
}
