//
//  Dependencies.swift
//  Notes
//
//  Created by Yasuhiro Hatta on 2025/09/28.
//

let dependencies: Dependencies = DependenciesImpl()

protocol Dependencies {
    func resolve() -> AppDatabaseContext

    func resolve() -> NoteRepository

    func resolve() -> MainViewModel
    func resolve() -> NotesViewModel
    func resolve() -> NoteContentViewModel
}

class DependenciesImpl: Dependencies {
    private lazy var singleAppDatabaseContext = AppDatabaseContext()

    func resolve() -> AppDatabaseContext {
        return singleAppDatabaseContext
    }

    private lazy var singleNoteRepository = NoteRepository(
        database: resolve()
    )

    func resolve() -> NoteRepository {
        return singleNoteRepository
    }

    func resolve() -> MainViewModel {
        return MainViewModel()
    }

    func resolve() -> NotesViewModel {
        return NotesViewModel(
            noteRepository: resolve()
        )
    }

    func resolve() -> NoteContentViewModel {
        return NoteContentViewModel(
            noteRepository: resolve()
        )
    }
}
