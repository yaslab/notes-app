//
//  AppMain.swift
//  Notes
//
//  Created by Yasuhiro Hatta on 2025/09/28.
//

import SwiftUI

@main
struct AppMain: App {
    @AppDelegateAdaptor
    private var delegate: AppDelegate

    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
