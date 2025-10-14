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
                    HStack(spacing: 0) {
                        Text("Created: \(note.createdAt.formatted())")
                        if note.createdAt != note.updatedAt {
                            Text(", Updated: \(note.updatedAt.formatted())")
                        }
                        Spacer()
                    }

                    HStack(spacing: 0) {
                        Text("Due Date: ")
                        if let dueDate = note.dueDate {
                            Text(dueDate.rawValue)
                        } else {
                            Text("-")
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
                        Spacer()
                    }

                    TextField(
                        "Title",
                        text: Binding(
                            get: { note.title },
                            set: { noteContentModel.onTitleUpdate($0, for: note) }
                        )
                    )
                }

                ForEach(noteContentModel.attachments) { attachment in
                    NoteContentAttachmentEditor(attachment: attachment)
                }
                .scrollIndicators(.never)

                HStack {
                    Image(systemName: "plus")
                    Button("Text") {
                        noteContentModel.appendNewAttachment(type: .text, to: note)
                    }
                    Button("URL") {
                        noteContentModel.appendNewAttachment(type: .url, to: note)
                    }
                    Spacer()
                }
            }
            .padding()
        }
        .font(.body.monospaced())
    }
}
