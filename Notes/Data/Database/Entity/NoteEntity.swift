//
//  NoteEntity.swift
//  Notes
//
//  Created by Yasuhiro Hatta on 2025/09/29.
//

import Foundation
import GRDB

struct NoteEntity: Codable, FetchableRecord, PersistableRecord {
    static let databaseTableName = "note"

    static let attachments = hasMany(NoteAttachmentEntity.self)

    var attachments: QueryInterfaceRequest<NoteAttachmentEntity> {
        request(for: NoteEntity.attachments)
    }

    var id: UUID
    var title: String
}

extension NoteEntity {
    init(from model: Note) {
        self.id = model.id
        self.title = model.title
    }

    func toModel(attachments: [NoteAttachmentEntity] = []) -> Note {
        return Note(
            id: id,
            title: title,
            attachments: attachments.map { $0.toModel() }
        )
    }
}
