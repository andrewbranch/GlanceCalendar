//
//  Moment+Custom.swift
//  GlanceCalendar
//
//  Created by Andrew Branch on 11/10/18.
//  Copyright © 2018 Wheream.io. All rights reserved.
//

import SwiftMoment

extension Moment {
    func isSameMonth(_ moment: Moment) -> Bool {
        return (year, month) == (moment.year, moment.month)
    }
    func isSameDay(_ moment: Moment) -> Bool {
        return (year, month, day) == (moment.year, moment.month, moment.day)
    }
}
