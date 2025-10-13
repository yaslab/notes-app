//
//  NotesViewModel.swift
//  Notes
//
//  Created by Yasuhiro Hatta on 2025/09/28.
//

import Combine
import Foundation
import Logging
import Observation

@Observable
class NotesViewModel {
    // MARK: - Dependencies

    private let logger: Logger
    private let noteRepository: NoteRepository

    init(logger: Logger, noteRepository: NoteRepository) {
        self.logger = logger
        self.noteRepository = noteRepository
        self.bind()
    }

    // MARK: - Subscriptions

    @ObservationIgnored
    private var cancellables: Set<AnyCancellable> = []

    private func bind() {
        logger.trace()

        cancellables = []

        noteRepository.publisher
            .assertNoFailure()  // FIXME: Handle error properly
            .assign(to: \.notes, on: self)
            .store(in: &cancellables)
    }

    // MARK: - States

    private(set) var notes: [Note] = []

    // MARK: - Actions

    func createNote(title: String) {
        logger.trace()

        do {
            try noteRepository.create(title: title)
        } catch {
            // TODO: error handling
            logger.debug("\(error)")
        }
    }

    func delete(id: UUID) {
        logger.trace()

        do {
            try noteRepository.delete(id: id)
        } catch {
            // TODO: error handling
            logger.debug("\(error)")
        }
    }

    func delete(indices: IndexSet) {
        logger.trace()

        do {
            try indices.map { notes[$0].id }.forEach { id in
                try noteRepository.delete(id: id)
            }
        } catch {
            // TODO: error handling
            logger.debug("\(error)")
        }
    }
}
