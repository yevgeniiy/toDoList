//
//  TodoListSwiftUIApp.swift
//  TodoListSwiftUI
//
//  Created by Yevgenii Kryzhanivskyi on 16.04.2022.
//

import SwiftUI

@main
struct TodoListSwiftUIApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
