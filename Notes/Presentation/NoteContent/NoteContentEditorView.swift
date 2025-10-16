//
//  NoteContentEditorView.swift
//  Notes
//
//  Created by Yasuhiro Hatta on 2025/09/28.
//

import SwiftUI

struct NoteContentEditorView: View {
    let id: Note.ID

    @State var viewModel: NoteContentViewModel
    @State var isDueDatePickerPresented: Bool = false

    init(id: Note.ID) {
        self.id = id
        self.viewModel = dependencies.resolve(id: id)
    }

    var body: some View {
        if let note = viewModel.note {
            content(note: note)
                .onDisappear {
                    viewModel.onEditorDisappear()
                }
                .environment(viewModel)
        } else {
            Text("Loading...")
                .onAppear {
                    viewModel.onEditorAppear()
                }
        }
    }

    func content(note: Note) -> some View {
        ScrollView {
            LazyVStack {
                contentHeader(note: note)

                contentBody()

                contentFooter()
            }
            .padding()
        }
    }

    func contentHeader(note: Note) -> some View {
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
                            viewModel.onDueDateUpdate(date)
                        }
                    )
                    .padding()
                }
                Button("Clear") {
                    viewModel.onDueDateUpdate(nil)
                }
                Spacer()
            }

            TextField(
                "Title",
                text: Binding(
                    get: { note.title },
                    set: { viewModel.onTitleUpdate($0) }
                )
            )
        }
    }

    @ViewBuilder func contentBody() -> some View {
        @Bindable var viewModel = viewModel

        ForEach($viewModel.attachments) { $attachment in
            NoteContentAttachmentEditor(attachment: $attachment)
        }
        .scrollIndicators(.never)
    }

    func contentFooter() -> some View {
        HStack {
            Image(systemName: "plus")
            Button("Text") {
                viewModel.appendNewAttachment(type: .text)
            }
            Button("URL") {
                viewModel.appendNewAttachment(type: .url)
            }
            Spacer()
        }
    }
}
