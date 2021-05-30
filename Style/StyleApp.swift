//
//  StyleApp.swift
//  Style
//
//  Created by Vince Davis on 11/14/20.
//

import SwiftUI

@main
struct StyleApp: App {
    let persistenceController = PersistenceController.shared
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(SessionStore())
            //let data = (1...100).map { "Item \($0)" }
            //MainView()
        }
    }
}
