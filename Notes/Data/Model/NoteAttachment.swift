//
//  NoteAttachment.swift
//  Notes
//
//  Created by Yasuhiro Hatta on 2025/10/12.
//

import Foundation

struct NoteAttachment: Identifiable, Hashable, Sendable {
    struct ID: RawRepresentable, Hashable, Sendable {
        var rawValue: UUID

        nonisolated init(rawValue: UUID = UUID()) {
            self.rawValue = rawValue
        }
    }

    var id: ID
    var type: NoteAttachmentType
    var data: String
    var createdAt: Date
    var updatedAt: Date

    var noteId: Note.ID

    nonisolated init(id: ID, type: NoteAttachmentType, data: String, createdAt: Date, updatedAt: Date, belongsTo noteId: Note.ID) {
        self.id = id
        self.type = type
        self.data = data
        self.createdAt = createdAt
        self.updatedAt = updatedAt

        self.noteId = noteId
    }
}
