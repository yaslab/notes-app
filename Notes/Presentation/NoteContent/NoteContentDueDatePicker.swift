//
//  NoteContentDueDatePicker.swift
//  Notes
//
//  Created by Yasuhiro Hatta on 2025/10/13.
//

import SwiftUI

struct NoteContentDueDatePicker: View {
    @Environment(\.dismiss) var dismiss

    @State var selection: Date = .now

    let onSubmit: (DateOnly) -> Void

    var body: some View {
        VStack {
            DatePicker(
                "Due Date",
                selection: $selection,
                displayedComponents: .date
            )
            .datePickerStyle(.graphical)

            HStack {
                Button("Cancel", role: .cancel) {
                    dismiss()
                }
                Button("Set") {
                    if let date = DateOnly(from: selection) {
                        onSubmit(date)
                    }
                    dismiss()
                }
            }
        }
    }
}
