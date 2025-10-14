//
//  NoteContentViewModel.swift
//  Notes
//
//  Created by Yasuhiro Hatta on 2025/09/28.
//

import Foundation
import Observation

@Observable
class NoteContentViewModel {
    // MARK: - Dependencies

    private let noteRepository: NoteRepository
    private let noteAttachmentRepository: NoteAttachmentRepository

    init(
        noteRepository: NoteRepository,
        noteAttachmentRepository: NoteAttachmentRepository
    ) {
        self.noteRepository = noteRepository
        self.noteAttachmentRepository = noteAttachmentRepository
    }

    // MARK: - States

    private(set) var note: Note? = nil
    private(set) var attachments: [NoteAttachment] = []

    // MARK: - Events

    func onEditorAppear(id: Note.ID) {
        do {
            try syncNote(id: id)
        } catch {
            // TODO: error handling
            print(error)
        }
    }

    func onEditorDisappear() {
        self.note = nil
        self.attachments = []
    }

    func onTitleUpdate(_ newValue: String, for note: Note) {
        do {
            try noteRepository.updateNote(title: newValue, for: note.id)
            try syncNote(id: note.id)
        } catch {
            // TODO: error handling
            print(error)
        }
    }

    func onDueDateUpdate(_ newValue: DateOnly?, for note: Note) {
        do {
            if let newValue {
                try noteRepository.updateNote(dueDate: newValue, for: note.id)
            } else {
                try noteRepository.setDueDateToNull(for: note.id)
            }
            try syncNote(id: note.id)
        } catch {
            // TODO: error handling
            print(error)
        }
    }

    func onAttachmentDataUpdate(_ newValue: String, for attachment: NoteAttachment) {
        do {
            try noteAttachmentRepository.updateAttachment(data: newValue, for: attachment.id)
            try syncNote(id: attachment.noteId)

            //            if let index = self.note?.attachments.firstIndex(of: attachment) {
            //                self.note?.attachments[index].data = newValue
            //            }
        } catch {
            // TODO: error handling
            print(error)
        }
    }

    // MARK: - Actions

    func appendNewAttachment(to note: Note) {
        do {
            try noteAttachmentRepository.createAttachment(type: .text, data: "", to: note.id)
            try syncNote(id: note.id)
        } catch {
            // TODO: error handling
            print(error)
        }
    }

    func deleteAttachment(_ attachment: NoteAttachment) {
        do {
            _ = try noteAttachmentRepository.deleteAttachment(by: attachment.id)
            try syncNote(id: attachment.noteId)
        } catch {
            // TODO: error handling
            print(error)
        }
    }

    // MARK: - UseCase

    func fetchNote(id: Note.ID) throws -> (Note, [NoteAttachment])? {
        guard let note = try noteRepository.fetchNote(by: id) else {
            return nil
        }

        let attachments = try noteAttachmentRepository.fetchAttachments(for: note)

        return (note, attachments)
    }

    // MARK: Common

    func syncNote(id: Note.ID) throws {
        guard let (note, attachments) = try fetchNote(id: id) else {
            return
        }

        self.note = note
        self.attachments = attachments
    }
}
