//
//  NoteContentView.swift
//  Notes
//
//  Created by Yasuhiro Hatta on 2025/09/28.
//

import SwiftUI

struct NoteContentView: View {
    @Environment(MainViewModel.self) var mainModel: MainViewModel

    @State var model: NoteContentViewModel = dependencies.resolve()

    var body: some View {
        NavigationStack {
            if let id = mainModel.selection {
                NoteContentEditorView(id: id)
                    .id(id)
            } else {
                NoteContentEmptyView()
            }
        }
        .environment(model)
    }
}
