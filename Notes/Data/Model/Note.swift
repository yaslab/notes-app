//
//  Note.swift
//  Notes
//
//  Created by Yasuhiro Hatta on 2025/09/28.
//

import Foundation

struct Note: Identifiable, Hashable, Sendable {
    struct ID: RawRepresentable, Hashable, Sendable {
        var rawValue: UUID

        nonisolated init(rawValue: UUID = UUID()) {
            self.rawValue = rawValue
        }
    }

    var id: ID
    var title: String
    var dueDate: DateOnly?
    var createdAt: Date
    var updatedAt: Date

    nonisolated init(id: ID, title: String, dueDate: DateOnly?, createdAt: Date, updatedAt: Date) {
        self.id = id
        self.title = title
        self.dueDate = dueDate
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
