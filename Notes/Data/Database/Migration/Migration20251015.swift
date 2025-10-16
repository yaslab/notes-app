//
//  Migration20251015.swift
//  Notes
//
//  Created by Yasuhiro Hatta on 2025/10/16.
//

import GRDB

class Migration20251015 {
    static func register(_ migrator: inout DatabaseMigrator) {
        migrator.registerMigration("20251015") { db in
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
    }
}
