//
//  NoteContentAttachmentEditor.swift
//  Notes
//
//  Created by Yasuhiro Hatta on 2025/10/13.
//

import SwiftUI

struct NoteContentAttachmentEditor: View {
    @Environment(NoteContentViewModel.self) var noteContentModel: NoteContentViewModel

    @State var text: String = ""
    @State var selection: TextSelection? = nil

    @State var isConfirmationDialogPresented: Bool = false

    let attachment: NoteAttachment

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button("Delete", systemImage: "trash", role: .destructive) {
                    isConfirmationDialogPresented = true
                }
                .confirmationDialog(deletionConfirmationMessage(), isPresented: $isConfirmationDialogPresented) {
                    Button("Delete", role: .destructive) {
                        noteContentModel.deleteAttachment(attachment)
                    }
                    Button("Cancel", role: .cancel) {
                    }
                }
            }
            TextEditor(text: $text, selection: $selection)
                .textEditorStyle(.plain)
                .frame(minHeight: 88)
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(.separator)
                }
        }
        .onAppear {
            text = attachment.data
        }
        .onChange(of: text) { oldValue, newValue in
            noteContentModel.onAttachmentDataUpdate(newValue, for: attachment)
        }
    }

    func deletionConfirmationMessage() -> String {
        var message = "Delete \""
        if text.count <= 128 {
            message += text
        } else {
            message += text.prefix(128)
            message += "..."
        }
        message += "\"?"
        message.replace("\n", with: "\\n")
        return message
    }
}
