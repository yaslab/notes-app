//
//  NoteContentView.swift
//  Notes
//
//  Created by Yasuhiro Hatta on 2025/09/28.
//

import SwiftUI

struct NoteContentView: View {
    @Environment(MainViewModel.self) var mainViewModel: MainViewModel

    var body: some View {
        @Bindable var mainViewModel = mainViewModel

        NavigationStack {
            if let id = mainViewModel.selection, let index = mainViewModel.notes.firstIndex(where: { $0.id == id }) {
                NoteContentEditorView(note: $mainViewModel.notes[index])
                    .id(id)
            } else {
                NoteContentEmptyView()
            }
        }
    }
}
