//
//  NotesViewModel.swift
//  Notes
//
//  Created by Yasuhiro Hatta on 2025/09/28.
//

import Combine
import Foundation
import Observation

@Observable
class NotesViewModel {
    // MARK: - Dependencies

    private let noteRepository: NoteRepository

    init(noteRepository: NoteRepository) {
        self.noteRepository = noteRepository
        self.bind()
    }

    // MARK: - Subscriptions

    @ObservationIgnored
    private var cancellables: Set<AnyCancellable> = []

    private func bind() {
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
        do {
            try noteRepository.create(title: title)
        } catch {
            // TODO: error handling
            print(error)
        }
    }

    func delete(id: UUID) {
        do {
            try noteRepository.delete(id: id)
        } catch {
            // TODO: error handling
            print(error)
        }
    }

    func delete(indices: IndexSet) {
        do {
            try indices.map { notes[$0].id }.forEach { id in
                try noteRepository.delete(id: id)
            }
        } catch {
            // TODO: error handling
            print(error)
        }
    }
}
