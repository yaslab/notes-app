//
//  NoteContentEditorView.swift
//  Notes
//
//  Created by Yasuhiro Hatta on 2025/09/28.
//

import SwiftUI

struct NoteContentEditorView: View {
    @Environment(NoteContentViewModel.self) var noteContentModel: NoteContentViewModel

    let id: UUID

    var body: some View {
        if let note = noteContentModel.note {
            content(note: note)
                .onDisappear {
                    noteContentModel.onEditorDisappear()
                }
        } else {
            Text("Loading...")
                .onAppear {
                    noteContentModel.onEditorAppear(id: id)
                }
        }
    }

    func content(note: Note) -> some View {
        ScrollView {
            LazyVStack {
                TextField(
                    "Title",
                    text: Binding(
                        get: { note.title },
                        set: { noteContentModel.onTitleUpdate($0, for: note) }
                    )
                )

                ForEach(note.attachments) { attachment in
                    NoteContentAttachmentEditor(attachment: attachment)
                }
                .scrollIndicators(.never)
            }
            .padding()
        }
        .font(.body.monospaced())
        .toolbar {
            ToolbarItem {
                attachButton(note: note)
            }
            ToolbarItem {
                saveButton()
            }
        }
    }

    func attachButton(note: Note) -> some View {
        Menu("Attach") {
            Button("Free Text", systemImage: "text.badge.plus") {
                noteContentModel.appendNewAttachment(to: note)
            }
            Button("URL", systemImage: "text.badge.plus") {
            }
        }
    }

    func saveButton() -> some View {
        Button("Save", systemImage: "square.and.arrow.down") {
        }
    }
}
