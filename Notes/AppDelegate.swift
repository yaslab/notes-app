//
//  AppDelegate.swift
//  Notes
//
//  Created by Yasuhiro Hatta on 2025/10/13.
//

import SwiftUI

#if os(macOS)

typealias AppDelegateAdaptor = NSApplicationDelegateAdaptor

class AppDelegate: NSObject, NSApplicationDelegate {
    // MARK: Launching Applications

    func applicationDidFinishLaunching(_ notification: Notification) {
        return
    }

    // MARK: Terminating Applications

    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
        return .terminateNow
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }

    func applicationWillTerminate(_ notification: Notification) {
        return
    }
}

#else

typealias AppDelegateAdaptor = UIApplicationDelegateAdaptor

class AppDelegate: NSObject, UIApplicationDelegate {
    // MARK: Initializing the app

    func application(_ application: UIApplication, didFinishLaunchingWithOptions options: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }
}

#endif
