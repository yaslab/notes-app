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

    init(noteRepository: NoteRepository) {
        self.noteRepository = noteRepository
    }

    // MARK: - States

    private(set) var note: Note? = nil
    private(set) var attachments: [NoteAttachment] = []

    // MARK: - Events

    func onEditorAppear(id: UUID) {
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
            try noteRepository.update(title: newValue, for: note)
            try syncNote(id: note.id)
        } catch {
            // TODO: error handling
            print(error)
        }
    }

    func onAttachmentDataUpdate(_ newValue: String, for attachment: NoteAttachment) {
        do {
            try noteRepository.updateAttachment(data: newValue, for: attachment)
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
            try noteRepository.createAttachment(type: "text", data: "", to: note)
            try syncNote(id: note.id)
        } catch {
            // TODO: error handling
            print(error)
        }
    }

    func deleteAttachment(_ attachment: NoteAttachment) {
        do {
            _ = try noteRepository.deleteAttachment(for: attachment)
            try syncNote(id: attachment.noteId)
        } catch {
            // TODO: error handling
            print(error)
        }
    }

    // MARK: - UseCase

    func fetchNote(id: UUID) throws -> (Note, [NoteAttachment])? {
        guard let note = try noteRepository.fetchOne(id: id) else {
            return nil
        }

        let attachments = try noteRepository.fetchAttachments(for: note)

        return (note, attachments)
    }

    // MARK: Common

    func syncNote(id: UUID) throws {
        guard let (note, attachments) = try fetchNote(id: id) else {
            return
        }

        self.note = note
        self.attachments = attachments
    }
}
