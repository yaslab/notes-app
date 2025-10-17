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

    private let note: Note
    private let noteRepository: NoteRepository
    private let noteAttachmentRepository: NoteAttachmentRepository

    init(
        note: Note,
        noteRepository: NoteRepository,
        noteAttachmentRepository: NoteAttachmentRepository
    ) {
        self.note = note
        self.noteRepository = noteRepository
        self.noteAttachmentRepository = noteAttachmentRepository
        self.bind()
    }

    // MARK: - Subscriptions

    @ObservationIgnored
    private var subjects: [NoteAttachment.ID: PassthroughSubject<String, Never>] = [:]
    @ObservationIgnored
    private var cancellables: Set<AnyCancellable> = []

    func bind() {
        noteAttachmentRepository.publisher(for: note)
            .assertNoFailure()  // FIXME: Handle error properly
            .assign(to: \.attachments, on: self)
            .store(in: &cancellables)
    }

    // MARK: - States

    var attachments: [NoteAttachment] = []

    // MARK: - Events

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
            try noteRepository.updateNote(title: newValue, for: note.id)
        } catch {
            // TODO: error handling
            print(error)
        }
    }

    func onDueDateUpdate(_ newValue: DateOnly?) {
        do {
            if let newValue {
                try noteRepository.updateNote(dueDate: newValue, for: note.id)
            } else {
                try noteRepository.setDueDateToNull(for: note.id)
            }
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
                        try self?.noteAttachmentRepository.updateAttachment(data: value, for: attachment.id)
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
            try noteAttachmentRepository.createAttachment(type: type, data: "", to: note.id)
        } catch {
            // TODO: error handling
            print(error)
        }
    }

    func deleteAttachment(_ attachment: NoteAttachment) {
        do {
            _ = try noteAttachmentRepository.deleteAttachment(by: attachment.id)
        } catch {
            // TODO: error handling
            print(error)
        }
    }
}
