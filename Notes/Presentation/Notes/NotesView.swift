//
//  NotesView.swift
//  Notes
//
//  Created by Yasuhiro Hatta on 2025/09/28.
//

import SwiftUI

struct NotesView: View {
    @Environment(MainViewModel.self) var mainViewModel: MainViewModel

    var body: some View {
        NavigationStack {
            list()
                .toolbar {
                    ToolbarItem {
                        appendButton()
                    }
                }
        }
    }

    @ViewBuilder func list() -> some View {
        @Bindable var mainViewModel = mainViewModel

        List(selection: $mainViewModel.selection) {
            ForEach(mainViewModel.notes) { note in
                cell(note: note)
                    .contextMenu {
                        Button("Delete", systemImage: "trash") {
                            mainViewModel.deleteNote(by: note.id)
                        }
                    }
                    .id(note.id)
            }
            .onDelete { indices in
                mainViewModel.deleteNotes(by: indices)
            }
        }
    }

    func cell(note: Note) -> some View {
        Text(title(for: note))
    }

    func appendButton() -> some View {
        Button("Add", systemImage: "square.and.pencil") {
            mainViewModel.createNote(title: "")
        }
    }

    func title(for note: Note) -> String {
        if note.title.isEmpty {
            return "(Untitled)"
        } else {
            return note.title
        }
    }
}

#Preview {
    NotesView()
}
