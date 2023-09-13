//
//  iOS_LearningApp.swift
//  iOS-Learning
//
//  Created by htcuser on 13/09/23.
//

import SwiftUI

@main
struct iOS_LearningApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
