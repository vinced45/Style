//
//  DateStyle.swift
//  Style
//
//  Created by Vince Davis on 1/11/21.
//

import Foundation

struct DateStyle {
    static func getRelativeDate(for date: Date) -> String {
        // ask for the full relative date
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full

        // get exampleDate relative to the current date
        let relativeDate = formatter.localizedString(for: date, relativeTo: Date())

        return relativeDate
    }
}
