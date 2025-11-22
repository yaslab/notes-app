//
//  DateOnly.swift
//  Notes
//
//  Created by Yasuhiro Hatta on 2025/10/13.
//

import Foundation

struct DateOnly: Hashable, Sendable {
    let year: Int
    let month: Int
    let day: Int

    nonisolated init?(year: Int, month: Int, day: Int) {
        guard 1 <= year, year <= 9999 else {
            return nil
        }
        guard 1 <= month, month <= 12 else {
            return nil
        }

        let calendar = Calendar(identifier: .gregorian)

        guard let thisMonth = calendar.date(from: DateComponents(year: year, month: month, day: 1)) else {
            return nil
        }
        guard let nextMonth = calendar.date(byAdding: .month, value: 1, to: thisMonth) else {
            return nil
        }
        guard let lastDayOfThisMonth = calendar.date(byAdding: .day, value: -1, to: nextMonth) else {
            return nil
        }

        guard 1 <= day, day <= calendar.component(.day, from: lastDayOfThisMonth) else {
            return nil
        }

        self.year = year
        self.month = month
        self.day = day
    }
}

extension DateOnly: RawRepresentable {
    nonisolated var rawValue: String {
        return String(format: "%04d-%02d-%02d", year, month, day)
    }

    nonisolated init?(rawValue: String) {
        let components = rawValue.components(separatedBy: "-")

        guard components.count == 3 else {
            return nil
        }

        guard components[0].count == 4, let year = Int(components[0]),
            components[1].count == 2, let month = Int(components[1]),
            components[2].count == 2, let day = Int(components[2])
        else {
            return nil
        }

        self.init(year: year, month: month, day: day)
    }
}

extension DateOnly {
    nonisolated init?(from date: Date, timeZone: TimeZone = .current) {
        var calendar = Calendar(identifier: .gregorian)

        calendar.timeZone = timeZone

        self.init(
            year: calendar.component(.year, from: date),
            month: calendar.component(.month, from: date),
            day: calendar.component(.day, from: date)
        )
    }
}
