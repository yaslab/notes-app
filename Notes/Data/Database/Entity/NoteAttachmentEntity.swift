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

    static let notes = belongsTo(NoteEntity.self)

    var notes: QueryInterfaceRequest<NoteEntity> {
        request(for: NoteAttachmentEntity.notes)
    }

    var id: UUID
    var type: String
    var data: String

    var noteId: UUID
}

extension NoteAttachmentEntity {
    init(from model: NoteAttachment) {
        self.id = model.id
        self.type = model.type
        self.data = model.data
        self.noteId = model.noteId
    }

    func toModel() -> NoteAttachment {
        NoteAttachment(
            id: id,
            type: type,
            data: data,
            belongsTo: noteId
        )
    }
}
