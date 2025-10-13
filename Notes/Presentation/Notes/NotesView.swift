//
//  NotesView.swift
//  Notes
//
//  Created by Yasuhiro Hatta on 2025/09/28.
//

import SwiftUI

struct NotesView: View {
    @Environment(MainViewModel.self) var mainModel: MainViewModel

    @State var model: NotesViewModel = dependencies.resolve()

    var body: some View {
        NavigationStack {
            @Bindable var mainModel = mainModel
            List(selection: $mainModel.selection) {
                ForEach(model.notes) { item in
                    Text(title(for: item))
                        .contextMenu {
                            Button("Delete", systemImage: "trash") {
                                model.delete(id: item.id)
                            }
                        }
                        .id(item.id)
                }
                .onDelete { indices in
                    model.delete(indices: indices)
                }
            }
            .toolbar(content: appendButton)
        }
    }

    func appendButton() -> some View {
        Button("Add", systemImage: "document.badge.plus") {
            model.createNote(title: "")
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
