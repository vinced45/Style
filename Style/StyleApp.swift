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

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
