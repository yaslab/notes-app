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
        NavigationStack {
            if let id = mainViewModel.selection {
                NoteContentEditorView(id: id)
                    .id(id)
            } else {
                NoteContentEmptyView()
            }
        }
    }
}
