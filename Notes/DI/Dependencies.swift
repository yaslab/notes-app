//
//  Dependencies.swift
//  Notes
//
//  Created by Yasuhiro Hatta on 2025/09/28.
//

import Logging

let dependencies: Dependencies = DependenciesImpl()

protocol Dependencies {
    func resolve() -> Logger

    func resolve() -> AppDatabaseContext

    func resolve() -> NoteRepository
    func resolve() -> NoteAttachmentRepository

    func resolve() -> MainViewModel
    func resolve() -> NotesViewModel
    func resolve() -> NoteContentViewModel
}

class DependenciesImpl: Dependencies {
    private lazy var singleLogger = AppLogger.make()

    func resolve() -> Logger {
        return singleLogger
    }

    private lazy var singleAppDatabaseContext = AppDatabaseContext(
        logger: resolve()
    )

    func resolve() -> AppDatabaseContext {
        return singleAppDatabaseContext
    }

    private lazy var singleNoteRepository = NoteRepository(
        database: resolve()
    )

    func resolve() -> NoteRepository {
        return singleNoteRepository
    }

    private lazy var singleNoteAttachmentRepository = NoteAttachmentRepository(
        database: resolve()
    )

    func resolve() -> NoteAttachmentRepository {
        return singleNoteAttachmentRepository
    }

    func resolve() -> MainViewModel {
        return MainViewModel()
    }

    func resolve() -> NotesViewModel {
        return NotesViewModel(
            logger: resolve(),
            noteRepository: resolve()
        )
    }

    func resolve() -> NoteContentViewModel {
        return NoteContentViewModel(
            noteRepository: resolve(),
            noteAttachmentRepository: resolve()
        )
    }
}
