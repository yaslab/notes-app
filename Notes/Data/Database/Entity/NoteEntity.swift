//
//  NoteEntity.swift
//  Notes
//
//  Created by Yasuhiro Hatta on 2025/09/29.
//

import Foundation
import GRDB

struct NoteEntity: Codable, FetchableRecord, PersistableRecord {
    static let databaseTableName = "Note"

    static func databaseUUIDEncodingStrategy(for column: String) -> DatabaseUUIDEncodingStrategy {
        return .lowercaseString
    }

    static func databaseDateEncodingStrategy(for column: String) -> DatabaseDateEncodingStrategy {
        return .timeIntervalSince1970
    }

    static func databaseDateDecodingStrategy(for column: String) -> DatabaseDateDecodingStrategy {
        return .timeIntervalSince1970
    }

    static let attachments = hasMany(NoteAttachmentEntity.self)

    var attachments: QueryInterfaceRequest<NoteAttachmentEntity> {
        request(for: NoteEntity.attachments)
    }

    enum Columns {
        static let title = Column("title")
        static let priority = Column("priority")
        static let dueDate = Column("dueDate")
        static let createdAt = Column("createdAt")
        static let updatedAt = Column("updatedAt")
    }

    var id: UUID
    var title: String
    var priority: NotePriority
    var dueDate: DateOnlyDatabaseValue?
    var createdAt: Date
    var updatedAt: Date
}

extension NoteEntity {
    init(from model: Note) {
        self.id = model.id.rawValue
        self.title = model.title
        self.priority = model.priority
        self.dueDate = DateOnlyDatabaseValue(from: model.dueDate)
        self.createdAt = model.createdAt
        self.updatedAt = model.updatedAt
    }

    func toModel() -> Note {
        return Note(
            id: Note.ID(rawValue: id),
            title: title,
            priority: priority,
            dueDate: dueDate?.toModel(),
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}
