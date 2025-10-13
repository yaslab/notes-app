//
//  DateOnly.swift
//  Notes
//
//  Created by Yasuhiro Hatta on 2025/10/13.
//

import Foundation

struct DateOnly: RawRepresentable, Codable, Hashable, Sendable {
    let rawValue: String

    init(rawValue: String) {
        self.rawValue = rawValue
    }
}

extension DateOnly {
    init(from date: Date, timeZone: TimeZone = .current) {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = timeZone
        self.init(
            year: calendar.component(.year, from: date),
            month: calendar.component(.month, from: date),
            day: calendar.component(.day, from: date)
        )
    }
}

extension DateOnly {
    init(year: Int, month: Int, day: Int) {
        // TODO: Validate
        self.rawValue = String(format: "%04d-%02d-%02d", year, month, day)
    }

    var year: Int {
        Int(rawValue.prefix(4))!
    }

    var month: Int {
        Int(rawValue.dropFirst(5).prefix(2))!
    }

    var day: Int {
        Int(rawValue.suffix(2))!
    }
}
