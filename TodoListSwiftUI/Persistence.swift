//
//  Persistence.swift
//  TodoListSwiftUI
//
//  Created by Yevgenii Kryzhanivskyi on 16.04.2022.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        var taskIsDone = false
        for _ in 0..<6 {
            let task = TaskEntity(context: viewContext)
            task.name = "Watch the movie"
            task.priorityValue = "normal"
            task.isDone = taskIsDone
            task.createDate = Date()
            taskIsDone.toggle()
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "TodoListSwiftUI")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                ErrorHandling.shared.handle(error: error)
            }
        })
    }
    
    func save() {
        
        let context = container.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error: \(error)")
                ErrorHandling.shared.handle(error: error)
            }
        }
    }
}
