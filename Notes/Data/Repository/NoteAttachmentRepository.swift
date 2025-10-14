//
//  NoteAttachmentRepository.swift
//  Notes
//
//  Created by Yasuhiro Hatta on 2025/10/14.
//

import Combine
import Foundation
import GRDB

class NoteAttachmentRepository {
    private let database: AppDatabaseContext

    init(database: AppDatabaseContext) {
        self.database = database
    }
}

extension NoteAttachmentRepository {
    func fetchAttachments(for note: Note) throws -> [NoteAttachment] {
        try database.queue.read { db in
            try NoteEntity(from: note).attachments.fetchAll(db)
                .map { $0.toModel() }
        }
    }

    func createAttachment(type: NoteAttachmentType, data: String, to noteId: Note.ID) throws {
        let date = Date()
        let entity = NoteAttachmentEntity(
            id: UUID(),
            type: type,
            data: data,
            createdAt: date,
            updatedAt: date,
            noteId: noteId.rawValue
        )

        try database.queue.write { db in
            try entity.insert(db)
        }
    }

    func updateAttachment(data: String? = nil, for id: NoteAttachment.ID) throws {
        try database.queue.write { db in
            guard var entity = try NoteAttachmentEntity.fetchOne(db, key: id.rawValue) else {
                return
            }

            try entity.updateChanges(db) {
                var changed = false
                if let data, $0.data != data {
                    $0.data = data
                    changed = true
                }
                if changed {
                    $0.updatedAt = .now
                }
            }
        }
    }

    func deleteAttachment(by id: NoteAttachment.ID) throws -> Bool {
        try database.queue.write { db in
            try NoteAttachmentEntity.deleteOne(db, key: id.rawValue)
        }
    }
}
