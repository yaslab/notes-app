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
            @Bindable var mainViewModel = mainViewModel
            List(selection: $mainViewModel.selection) {
                ForEach($mainViewModel.notes) { $item in
                    Text(title(for: item))
                        .contextMenu {
                            Button("Delete", systemImage: "trash") {
                                mainViewModel.deleteNote(by: item.id)
                            }
                        }
                        .id(item.id)
                }
                .onDelete { indices in
                    mainViewModel.deleteNotes(by: indices)
                }
            }
            .toolbar(content: appendButton)
        }
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
