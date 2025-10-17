//
//  MainViewModel.swift
//  Notes
//
//  Created by Yasuhiro Hatta on 2025/09/28.
//

import Combine
import Foundation
import Observation

@Observable
class MainViewModel {
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
        //logger.trace()

        cancellables = []

        noteRepository.publisher
            .assertNoFailure()  // FIXME: Handle error properly
            .assign(to: \.notes, on: self)
            .store(in: &cancellables)
    }

    // MARK: - States

    var notes: [Note] = []
    var selection: Note.ID? = nil

    // MARK: - Actions

    func createNote(title: String) {
        //logger.trace()

        do {
            try noteRepository.createNote(title: title)
        } catch {
            // TODO: error handling
            print("\(error)")
        }
    }

    func deleteNote(by id: Note.ID) {
        do {
            try noteRepository.deleteNote(by: id)
        } catch {
            // TODO: error handling
            print("\(error)")
        }
    }

    func deleteNotes(by sss: IndexSet) {
        do {
            // FIXME: Make the following loop into one transaction
            let notesToDelete = sss.map { i in notes[i] }
            for note in notesToDelete {
                try noteRepository.deleteNote(by: note.id)
            }
        } catch {
            // TODO: error handling
            print("\(error)")
        }
    }
}
