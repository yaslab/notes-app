//
//  NoteContentViewModel.swift
//  Notes
//
//  Created by Yasuhiro Hatta on 2025/09/28.
//

import Combine
import Foundation
import Observation

@Observable
class NoteContentViewModel {
    // MARK: - Dependencies

    private let id: Note.ID
    private let noteRepository: NoteRepository
    private let noteAttachmentRepository: NoteAttachmentRepository

    init(
        id: Note.ID,
        noteRepository: NoteRepository,
        noteAttachmentRepository: NoteAttachmentRepository
    ) {
        self.id = id
        self.noteRepository = noteRepository
        self.noteAttachmentRepository = noteAttachmentRepository
    }

    // MARK: - Subscriptions

    @ObservationIgnored
    private var subjects: [NoteAttachment.ID: PassthroughSubject<String, Never>] = [:]
    @ObservationIgnored
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - States

    private(set) var note: Note? = nil
    var attachments: [NoteAttachment] = []

    // MARK: - Events

    func onEditorAppear() {
        do {
            try syncNote()
        } catch {
            // TODO: error handling
            print(error)
        }
    }

    func onEditorDisappear() {
        do {
            for attachment in attachments {
                try noteAttachmentRepository.updateAttachment(data: attachment.data, for: attachment.id)
            }
        } catch {
            // TODO: error handling
            print(error)
        }
    }

    func onTitleUpdate(_ newValue: String) {
        do {
            try noteRepository.updateNote(title: newValue, for: id)
            try syncNote()
        } catch {
            // TODO: error handling
            print(error)
        }
    }

    func onDueDateUpdate(_ newValue: DateOnly?) {
        do {
            if let newValue {
                try noteRepository.updateNote(dueDate: newValue, for: id)
            } else {
                try noteRepository.setDueDateToNull(for: id)
            }
            try syncNote()
        } catch {
            // TODO: error handling
            print(error)
        }
    }

    func onAttachmentDataUpdate(for attachment: NoteAttachment) {
        if let subject = subjects[attachment.id] {
            subject.send(attachment.data)
        } else {
            let subject = PassthroughSubject<String, Never>()

            subjects[attachment.id] = subject

            subject.debounce(for: .seconds(2), scheduler: DispatchQueue.main)
                .handleEvents(receiveCancel: { print("cancel") })
                .sink { [weak self] value in
                    do {
                        print(value)
                        try self?.noteAttachmentRepository.updateAttachment(data: value, for: attachment.id)
                        try self?.syncNote()
                    } catch {
                        // TODO: error handling
                        print(error)
                    }
                }
                .store(in: &cancellables)

            subject.send(attachment.data)
        }
    }

    // MARK: - Actions

    func appendNewAttachment(type: NoteAttachmentType) {
        do {
            try noteAttachmentRepository.createAttachment(type: type, data: "", to: id)
            try syncNote()
        } catch {
            // TODO: error handling
            print(error)
        }
    }

    func deleteAttachment(_ attachment: NoteAttachment) {
        do {
            _ = try noteAttachmentRepository.deleteAttachment(by: attachment.id)
            try syncNote()
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

    func syncNote() throws {
        guard let (note, attachments) = try fetchNote(id: id) else {
            return
        }

        self.note = note
        self.attachments = attachments
    }
}
