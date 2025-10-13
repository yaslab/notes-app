//
//  NoteContentEditorView.swift
//  Notes
//
//  Created by Yasuhiro Hatta on 2025/09/28.
//

import SwiftUI

struct NoteContentEditorView: View {
    @Environment(NoteContentViewModel.self) var noteContentModel: NoteContentViewModel

    @State var isDueDatePickerPresented: Bool = false

    let id: Note.ID

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
                VStack {
                    HStack {
                        Text("Due Date")
                        if let dueDate = note.dueDate {
                            Text(dueDate.rawValue)
                        }
                        Button("Set") {
                            isDueDatePickerPresented = true
                        }
                        .popover(isPresented: $isDueDatePickerPresented) {
                            NoteContentDueDatePicker(
                                onSubmit: { date in
                                    noteContentModel.onDueDateUpdate(date, for: note)
                                }
                            )
                            .padding()
                        }
                        Button("Clear") {
                            noteContentModel.onDueDateUpdate(nil, for: note)
                        }
                    }

                    TextField(
                        "Title",
                        text: Binding(
                            get: { note.title },
                            set: { noteContentModel.onTitleUpdate($0, for: note) }
                        )
                    )

                    HStack {
                        Spacer()
                        Text(note.updatedAt.formatted())
                    }
                    .font(.caption)
                }

                ForEach(noteContentModel.attachments) { attachment in
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
}
