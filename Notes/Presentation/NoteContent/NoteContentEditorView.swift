//
//  NoteContentEditorView.swift
//  Notes
//
//  Created by Yasuhiro Hatta on 2025/09/28.
//

import SwiftUI

struct NoteContentEditorView: View {
    @State var viewModel: NoteContentViewModel
    @State var isDueDatePickerPresented: Bool = false

    @Binding var note: Note

    init(note: Binding<Note>) {
        viewModel = dependencies.resolve(note: note.wrappedValue)
        _note = note
    }

    var body: some View {
        content()
            .onDisappear {
                viewModel.onEditorDisappear()
            }
            .environment(viewModel)
    }

    func content() -> some View {
        ScrollView {
            LazyVStack {
                contentHeader()

                contentBody()

                contentFooter()
            }
            .padding()
        }
    }

    func contentHeader() -> some View {
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

            TextField("Title", text: $note.title)
                .onChange(of: note.title) { oldValue, newValue in
                    viewModel.onTitleUpdate(newValue)
                }
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
