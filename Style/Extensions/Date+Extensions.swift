//
//  Date+Extensions.swift
//  Scene Me
//
//  Created by Vince Davis on 3/12/21.
//

import Foundation

extension Date {
    var relative: String {
        // ask for the full relative date
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full

        // get exampleDate relative to the current date
        let relativeDate = formatter.localizedString(for: self, relativeTo: Date())

        return relativeDate
    }
    
    static func createFrom(_ dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let date = dateFormatter.date(from: dateString)
        return date ?? Date()
    }
}
