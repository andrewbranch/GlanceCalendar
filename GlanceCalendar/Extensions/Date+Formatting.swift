import Foundation

class DateFormatters {
    public let dayOfWeek = DateFormatter()
    public let time = DateFormatter()
    public let date = DateFormatter()
    init() {
        dayOfWeek.setLocalizedDateFormatFromTemplate("E")
        time.dateStyle = .none
        time.timeStyle = .short
        date.dateStyle = .full
        date.timeStyle = .none
    }
    
    public static var shared: DateFormatters = {
        return DateFormatters()
    }()
}

extension Date {
    static func dayOfWeekAndTime() -> String {
        let date = Date(timeIntervalSinceNow: 0)
        let dayOfWeek = DateFormatters.shared.dayOfWeek.string(from: date)
        let time = DateFormatters.shared.time.string(from: date)
        return "\(dayOfWeek) \(time)"
    }
    
    static func fullDate() -> String {
        let date = Date(timeIntervalSinceNow: 0)
        return DateFormatters.shared.date.string(from: date)
    }
    
    func time() -> String {
        return DateFormatters.shared.time.string(from: self)
    }
}
