//
//  DateOnlyTests.swift
//  NotesTests
//
//  Created by Yasuhiro Hatta on 2025/09/28.
//

import Testing

@testable import Notes

struct DateOnlyTests {

    @Test(
        arguments: [
            (1, 1, 1),
            (2024, 2, 29),
            (2025, 10, 19),
            (9999, 12, 31),
        ]
    )
    func testInitFromComponents(year: Int, month: Int, day: Int) async throws {
        let date = try #require(DateOnly(year: year, month: month, day: day))
        #expect(date.year == year)
        #expect(date.month == month)
        #expect(date.day == day)
    }

    @Test(
        arguments: [
            (0, 1, 1),
            (1, 0, 1),
            (1, 1, 0),
            (10000, 1, 1),
            (1, 13, 1),
            (1, 1, 32),
            (2025, 2, 29),
        ]
    )
    func testInvalidComponents(year: Int, month: Int, day: Int) async throws {
        let date = DateOnly(year: year, month: month, day: day)
        #expect(date == nil)
    }

    @Test(
        arguments: [
            ("0001-01-01"),
            ("9999-12-31"),
            ("2024-02-29"),
        ]
    )
    func testInitFromRawValue(rawValue: String) async throws {
        let date = try #require(DateOnly(rawValue: rawValue))
        #expect(date.rawValue == rawValue)
    }

    @Test(
        arguments: [
            (""),
            ("2025"),
            ("2025-10"),
            ("1-01-01"),
            ("0001-1-01"),
            ("0001-01-1"),
            ("2025-02-29"),
            ("yyyy-mm-dd"),
        ]
    )
    func testInvalidRawValue(rawValue: String) async throws {
        let date = DateOnly(rawValue: rawValue)
        #expect(date == nil)
    }

}
