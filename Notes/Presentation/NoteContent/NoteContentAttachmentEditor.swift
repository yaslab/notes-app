//
//  NoteContentAttachmentEditor.swift
//  Notes
//
//  Created by Yasuhiro Hatta on 2025/10/13.
//

import SwiftUI

struct NoteContentAttachmentEditor: View {
    @Environment(NoteContentViewModel.self) var viewModel: NoteContentViewModel

    @Environment(\.openURL) var openURL

    @State var isConfirmationDialogPresented: Bool = false

    @Binding var attachment: NoteAttachment

    var body: some View {
        VStack {
            HStack {
                switch attachment.type {
                case .text:
                    Text("Notes")
                case .url:
                    Text("URL")
                }
                Spacer()
                if case .url = attachment.type {
                    Button("Open") {
                        if let url = URL(string: attachment.data) {
                            // FIXME: Only allow http and https
                            openURL(url)
                        }
                    }
                }
                Button("Delete", systemImage: "trash", role: .destructive) {
                    isConfirmationDialogPresented = true
                }
                .confirmationDialog(deletionConfirmationMessage(), isPresented: $isConfirmationDialogPresented) {
                    Button("Delete", role: .destructive) {
                        viewModel.deleteAttachment(attachment)
                    }
                    Button("Cancel", role: .cancel) {
                    }
                }
            }
            TextEditor(text: $attachment.data)
                .textEditorStyle(.plain)
                .font(.body.monospaced())
                .frame(minHeight: 88)
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(.separator)
                }
        }
        .onChange(of: attachment.data) { oldValue, newValue in
            viewModel.onAttachmentDataUpdate(for: attachment)
        }
    }

    func deletionConfirmationMessage() -> String {
        let text = attachment.data

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
