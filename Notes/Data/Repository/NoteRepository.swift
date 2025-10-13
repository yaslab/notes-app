//
//  NoteRepository.swift
//  Notes
//
//  Created by Yasuhiro Hatta on 2025/09/28.
//

import Combine
import Foundation
import GRDB

class NoteRepository {
    private let database: AppDatabaseContext

    init(database: AppDatabaseContext) {
        self.database = database
    }
}

extension NoteRepository {
    var publisher: AnyPublisher<[Note], Error> {
        let observation = ValueObservation.tracking { try NoteEntity.order(\.updatedAt.desc).fetchAll($0) }
        return observation.publisher(in: database.queue)
            .map { $0.map { $0.toModel() } }
            .eraseToAnyPublisher()
    }

    func fetchOne(id: UUID) throws -> Note? {
        try database.queue.read { db in
            try NoteEntity.fetchOne(db, key: id)?.toModel()
        }
    }

    func create(title: String) throws {
        let date = Date()
        let entity = NoteEntity(
            id: UUID(),
            title: title,
            createdAt: date,
            updatedAt: date
        )

        try database.queue.write { db in
            try entity.insert(db)
        }
    }

    func update(title: String? = nil, for note: Note) throws {
        var entity = NoteEntity(from: note)
        var changed = false

        if let title, entity.title != title {
            entity.title = title
            changed = true
        }

        if changed {
            entity.updatedAt = .now
            try database.queue.write { db in
                try entity.update(db)
            }
        }
    }

    func delete(id: UUID) throws {
        try database.queue.write { db in
            _ = try NoteEntity.deleteOne(db, key: id)
        }
    }
}

extension NoteRepository {
    func fetchAttachments(for note: Note) throws -> [NoteAttachment] {
        try database.queue.read { db in
            try NoteEntity(from: note).attachments.fetchAll(db)
                .map { $0.toModel() }
        }
    }

    func createAttachment(type: String, data: String, to note: Note) throws {
        let date = Date()
        let entity = NoteAttachmentEntity(
            id: UUID(),
            type: type,
            data: data,
            createdAt: date,
            updatedAt: date,
            noteId: note.id
        )

        try database.queue.write { db in
            try entity.insert(db)
        }
    }

    func updateAttachment(data: String? = nil, for attachment: NoteAttachment) throws {
        var entity = NoteAttachmentEntity(from: attachment)
        var changed = false

        if let data, entity.data != data {
            entity.data = data
            changed = true
        }

        if changed {
            entity.updatedAt = .now
            try database.queue.write { db in
                try entity.update(db)
            }
        }
    }

    func deleteAttachment(for attachment: NoteAttachment) throws -> Bool {
        try database.queue.write { db in
            try NoteAttachmentEntity.deleteOne(db, key: attachment.id)
        }
    }
}
