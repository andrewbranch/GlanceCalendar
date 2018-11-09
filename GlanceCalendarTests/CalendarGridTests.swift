import XCTest
import SwiftMoment
@testable import GlanceCalendar

class CalendarGridTests: XCTestCase {
    func testGetWeeks() {
        let calendar = CalendarGrid()
        let octoberWeeks = calendar.getWeeks(month: 10, year: 2018)
        XCTAssert(octoberWeeks.count == 5, "Has the correct number of weeks")
        XCTAssert(octoberWeeks.allSatisfy { $0.count == 7 }, "Each week has 7 days")
        XCTAssert(octoberWeeks[0][0].isEqualTo(moment([ "month": 9, "day": 30, "year": 2018 ])!), "First day is correct")
        XCTAssert(octoberWeeks[4][6].isEqualTo(moment([ "month": 11, "day": 3, "year": 2018 ])!), "Last day is correct")
    }
    
    func testGetWeeksWithDSTChange() {
        let calendar = CalendarGrid()
        let novemberWeeks = calendar.getWeeks(month: 11, year: 2018)
        XCTAssert(novemberWeeks.count == 5, "Has the correct number of weeks")
        XCTAssert(novemberWeeks[0][0].isEqualTo(moment([ "month": 10, "day": 28, "year": 2018 ])!), "First day is correct")
        XCTAssert(novemberWeeks[4][6].isEqualTo(moment([ "month": 12, "day": 1, "year": 2018 ])!), "Last day is correct")
    }
}
