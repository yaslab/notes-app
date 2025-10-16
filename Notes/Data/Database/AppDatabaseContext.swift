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

            try AppDatabaseContext.migrator().migrate(queue)

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

    static func migrator() -> DatabaseMigrator {
        var migrator = DatabaseMigrator()
        Migration20251015.register(&migrator)
        return migrator
    }
}
