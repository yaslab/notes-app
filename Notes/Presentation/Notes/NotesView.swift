//
//  NotesView.swift
//  Notes
//
//  Created by Yasuhiro Hatta on 2025/09/28.
//

import SwiftUI

struct NotesView: View {
    @Environment(MainViewModel.self) var mainViewModel: MainViewModel

    @State var viewModel: NotesViewModel = dependencies.resolve()

    var body: some View {
        NavigationStack {
            @Bindable var mainViewModel = mainViewModel
            List(selection: $mainViewModel.selection) {
                ForEach(viewModel.notes) { item in
                    Text(title(for: item))
                        .contextMenu {
                            Button("Delete", systemImage: "trash") {
                                viewModel.delete(id: item.id)
                            }
                        }
                        .id(item.id)
                }
                .onDelete { indices in
                    viewModel.delete(indices: indices)
                }
            }
            .toolbar(content: appendButton)
        }
    }

    func appendButton() -> some View {
        Button("Add", systemImage: "square.and.pencil") {
            viewModel.createNote(title: "")
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
