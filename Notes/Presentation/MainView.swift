//
//  MainView.swift
//  Notes
//
//  Created by Yasuhiro Hatta on 2025/09/28.
//

import SwiftUI

struct MainView: View {
    @State var viewModel: MainViewModel = dependencies.resolve()

    var body: some View {
        NavigationSplitView {
            NotesView()
        } detail: {
            NoteContentView()
        }
        .environment(viewModel)
    }
}
