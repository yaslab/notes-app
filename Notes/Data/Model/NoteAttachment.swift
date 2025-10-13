//
//  NoteAttachment.swift
//  Notes
//
//  Created by Yasuhiro Hatta on 2025/10/12.
//

import Foundation

struct NoteAttachment: Identifiable, Hashable, Sendable {
    var id: UUID
    var type: String
    var data: String
    var createdAt: Date
    var updatedAt: Date?

    var noteId: UUID

    nonisolated init(id: UUID, type: String, data: String, createdAt: Date, updatedAt: Date?, belongsTo noteId: UUID) {
        self.id = id
        self.type = type
        self.data = data
        self.createdAt = createdAt
        self.updatedAt = updatedAt

        self.noteId = noteId
    }
}
