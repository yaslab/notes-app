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

    func fetchOne(id: Note.ID) throws -> Note? {
        try database.queue.read { db in
            try NoteEntity.fetchOne(db, key: id.rawValue)?.toModel()
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

    func update(title: String? = nil, dueDate: DateOnly? = nil, for noteId: Note.ID) throws {
        try database.queue.write { db in
            guard var entity = try NoteEntity.fetchOne(db, key: noteId.rawValue) else {
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

    func setDueDateToNull(for noteId: Note.ID) throws {
        try database.queue.write { db in
            guard var entity = try NoteEntity.fetchOne(db, key: noteId.rawValue) else {
                return
            }

            try entity.updateChanges(db) {
                $0.dueDate = nil
                $0.updatedAt = .now
            }
        }
    }

    func delete(id: Note.ID) throws {
        try database.queue.write { db in
            _ = try NoteEntity.deleteOne(db, key: id.rawValue)
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

    func deleteAttachment(for id: NoteAttachment.ID) throws -> Bool {
        try database.queue.write { db in
            try NoteAttachmentEntity.deleteOne(db, key: id.rawValue)
        }
    }
}
