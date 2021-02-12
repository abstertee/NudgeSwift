//
//  NudgeApp.swift
//  Nudge
//
//  Created by Erik Gomez on 2/2/21.
//

import SwiftUI

// Thanks you ftiff
// Create an AppDelegate so the close button will terminate Nudge
// Technically not needed because we are now hiding those buttons
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        true
    }
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        print("App launched")
        HelperDelegate.shared.updateAuthTable()
        HelperDelegate.shared.helperStatus(completion: {
            installedStatus in
            debugPrint(installedStatus)
            OperationQueue.main.addOperation {
                //debugPrint("Here is the installed status \(((installedStatus) ? true : false))")
                debugPrint("HelperApp Installed Status: \(((installedStatus) ? true : false))")
                if installedStatus {
                    //debugPrint("Helper is installed")
                    debugPrint("Helper is installed")
                } else {
                    //debugPrint("Helper is not installed")
                    debugPrint("Helper is not installed")
                    HelperDelegate.shared.helperInstaller()
                    //self.helperInstaller()
                }
            }
        })
    }
    
}

@main
struct NudgeApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    let manager = try! PolicyManager() // TODO: handle errors
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(manager)
        }
        // Hide Title Bar
        .windowStyle(HiddenTitleBarWindowStyle())
    }
}
