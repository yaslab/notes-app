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

    // MARK: - Events

    func onEditorAppear(id: UUID) {
        do {
            let note = try noteRepository.fetchOne(id: id)
            self.note = note
        } catch {
            // TODO: error handling
            print(error)
        }
    }

    func onEditorDisappear() {
        self.note = nil
    }

    func onTitleUpdate(_ newValue: String, for note: Note) {
        do {
            try noteRepository.update(title: newValue, for: note)
            self.note = try noteRepository.fetchOne(id: note.id)
        } catch {
            // TODO: error handling
            print(error)
        }
    }

    func onAttachmentDataUpdate(_ newValue: String, for attachment: NoteAttachment) {
        do {
            try noteRepository.updateAttachment(data: newValue, for: attachment)
            self.note = try noteRepository.fetchOne(id: attachment.noteId)

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
            self.note = try noteRepository.fetchOne(id: note.id)
        } catch {
            // TODO: error handling
            print(error)
        }
    }

    func deleteAttachment(_ attachment: NoteAttachment) {
        do {
            _ = try noteRepository.deleteAttachment(for: attachment)
            self.note = try noteRepository.fetchOne(id: attachment.noteId)
        } catch {
            // TODO: error handling
            print(error)
        }
    }
}
