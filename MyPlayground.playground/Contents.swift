import Cocoa
import SwiftMoment

let now = Date(timeIntervalSinceNow: 0).timeIntervalSince1970
let nextMinute = Date(timeIntervalSince1970: now + 60 - now.truncatingRemainder(dividingBy: 60))
