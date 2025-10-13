//
//  Note.swift
//  Notes
//
//  Created by Yasuhiro Hatta on 2025/09/28.
//

import Foundation

struct Note: Identifiable, Hashable, Sendable {
    var id: UUID
    var title: String
    var attachments: [NoteAttachment]

    nonisolated init(id: UUID, title: String, attachments: [NoteAttachment]) {
        self.id = id
        self.title = title
        self.attachments = attachments
    }
}
