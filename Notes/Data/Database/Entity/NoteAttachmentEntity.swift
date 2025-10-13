//
//  NoteAttachmentEntity.swift
//  Notes
//
//  Created by Yasuhiro Hatta on 2025/10/12.
//

import Foundation
import GRDB

struct NoteAttachmentEntity: Codable, FetchableRecord, PersistableRecord {
    static let databaseTableName = "note_attachment"

    static func databaseUUIDEncodingStrategy(for column: String) -> DatabaseUUIDEncodingStrategy {
        return .lowercaseString
    }

    static func databaseDateEncodingStrategy(for column: String) -> DatabaseDateEncodingStrategy {
        return .timeIntervalSince1970
    }

    static func databaseDateDecodingStrategy(for column: String) -> DatabaseDateDecodingStrategy {
        return .timeIntervalSince1970
    }

    static let notes = belongsTo(NoteEntity.self)

    var notes: QueryInterfaceRequest<NoteEntity> {
        request(for: NoteAttachmentEntity.notes)
    }

    enum Columns {
        static let type = Column("type")
        static let data = Column("data")
        static let createdAt = Column("createdAt")
        static let updatedAt = Column("updatedAt")
    }

    var id: UUID
    var type: NoteAttachmentType
    var data: String
    var createdAt: Date
    var updatedAt: Date

    var noteId: UUID
}

extension NoteAttachmentEntity {
    init(from model: NoteAttachment) {
        self.id = model.id.rawValue
        self.type = model.type
        self.data = model.data
        self.createdAt = model.createdAt
        self.updatedAt = model.updatedAt

        self.noteId = model.noteId.rawValue
    }

    func toModel() -> NoteAttachment {
        NoteAttachment(
            id: NoteAttachment.ID(rawValue: id),
            type: type,
            data: data,
            createdAt: createdAt,
            updatedAt: updatedAt,
            belongsTo: Note.ID(rawValue: noteId)
        )
    }
}
