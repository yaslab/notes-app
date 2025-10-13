//
//  AppDatabaseContext.swift
//  Notes
//
//  Created by Yasuhiro Hatta on 2025/09/29.
//

import Foundation
import GRDB

class AppDatabaseContext {
    let queue: DatabaseQueue

    init(isInMemory: Bool = false) {
        do {
            let queue: DatabaseQueue

            if isInMemory {
                queue = try DatabaseQueue()
            } else {
                queue = try DatabaseQueue(path: AppDatabaseContext.path())
            }

            try queue.write { db in
                try db.create(table: NoteEntity.databaseTableName, options: .ifNotExists) { t in
                    t.primaryKey("id", .text)
                    t.column("title", .text).notNull()
                }
                try db.create(table: NoteAttachmentEntity.databaseTableName, options: .ifNotExists) { t in
                    t.primaryKey("id", .text)
                    t.column("type", .text).notNull()
                    t.column("data", .text).notNull()
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
        try fm.createDirectory(at: dir, withIntermediateDirectories: true)
        let file = dir.appending(component: "notes.sqlite")

        // For debugging
        print("Database file path: \(file.path(percentEncoded: false))")

        return file.path(percentEncoded: false)
    }
}
