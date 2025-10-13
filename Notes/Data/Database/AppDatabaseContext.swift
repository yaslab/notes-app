//
//  AppDatabaseContext.swift
//  Notes
//
//  Created by Yasuhiro Hatta on 2025/09/29.
//

import Foundation
import GRDB
import Logging

class AppDatabaseContext {
    private let logger: Logger
    let queue: DatabaseQueue

    init(logger: Logger, isInMemory: Bool = false) {
        self.logger = logger

        do {
            let queue: DatabaseQueue

            if isInMemory {
                queue = try DatabaseQueue()
            } else {
                queue = try DatabaseQueue(path: AppDatabaseContext.path())
            }

            logger.info("Database file path: \(queue.path)")

            try queue.write { db in
                try db.create(table: NoteEntity.databaseTableName, options: .ifNotExists) { t in
                    t.primaryKey("id", .text)
                    t.column("title", .text).notNull()
                    t.column("dueDate", .text)
                    t.column("createdAt", .double).notNull()
                    t.column("updatedAt", .double).notNull()
                }
                try db.create(table: NoteAttachmentEntity.databaseTableName, options: .ifNotExists) { t in
                    t.primaryKey("id", .text)
                    t.column("type", .text).notNull()
                    t.column("data", .text).notNull()
                    t.column("createdAt", .double).notNull()
                    t.column("updatedAt", .double).notNull()
                    t.belongsTo(NoteEntity.databaseTableName, onDelete: .cascade).notNull()
                }
            }

            self.queue = queue
        } catch {
            fatalError("Failed to initialize the database: \(error)")
        }
    }
}

extension AppDatabaseContext {
    static func path() throws -> String {
        let fm: FileManager = .default
        let dir = fm.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
            .appending(component: "Database")
        try fm.createDirectory(at: dir, withIntermediateDirectories: true)
        let file = dir.appending(component: "notes.sqlite")

        return file.path(percentEncoded: false)
    }
}
