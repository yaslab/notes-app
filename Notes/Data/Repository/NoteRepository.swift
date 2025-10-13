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

    func update(title: String? = nil, dueDate: DateOnly? = nil, for note: Note) throws {
        try database.queue.write { db in
            guard var entity = try NoteEntity.fetchOne(db, key: note.id) else {
                return
            }

            try entity.updateChanges(db) {
                var changed = false
                if let title, $0.title != title {
                    $0.title = title
                    changed = true
                }
                if let dueDate, $0.dueDate != dueDate {
                    $0.dueDate = dueDate
                    changed = true
                }
                if changed {
                    $0.updatedAt = .now
                }
            }
        }
    }

    func setDueDateToNull(for note: Note) throws {
        try database.queue.write { db in
            guard var entity = try NoteEntity.fetchOne(db, key: note.id) else {
                return
            }

            try entity.updateChanges(db) {
                $0.dueDate = nil
                $0.updatedAt = .now
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
        try database.queue.write { db in
            guard var entity = try NoteAttachmentEntity.fetchOne(db, key: attachment.id) else {
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

    func deleteAttachment(for attachment: NoteAttachment) throws -> Bool {
        try database.queue.write { db in
            try NoteAttachmentEntity.deleteOne(db, key: attachment.id)
        }
    }
}
