//
//  NSAppearance+Custom.swift
//  GlanceCalendar
//
//  Created by Andrew Branch on 5/19/19.
//  Copyright © 2019 Wheream.io. All rights reserved.
//

import AppKit

extension NSAppearance {
    @objc(rsIsDarkMode)
    public var isDarkMode: Bool {
        let isDarkMode: Bool
        
        if #available(macOS 10.14, *) {
            if self.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua {
                isDarkMode = true
            } else {
                isDarkMode = false
            }
        } else {
            isDarkMode = false
        }
        
        return isDarkMode
    }
}
