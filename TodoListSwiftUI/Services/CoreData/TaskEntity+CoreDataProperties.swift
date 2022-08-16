//
//  TaskEntity+CoreDataProperties.swift
//  TodoListSwiftUI
//
//  Created by Yevgenii Kryzhanivskyi on 16.08.2022.
//
//

import Foundation
import CoreData


extension TaskEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskEntity> {
        return NSFetchRequest<TaskEntity>(entityName: "TaskEntity")
    }

    @NSManaged public var createDate: Date?
    @NSManaged public var doneDate: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var isDone: Bool
    @NSManaged public var name: String
    @NSManaged public var priorityValue: String
    
    var priority: Priority {
        get {
            return Priority(rawValue: self.priorityValue) ?? Priority.normal
        } set {
            self.priorityValue = newValue.rawValue
        }
    }

    static var viewContext: NSManagedObjectContext {
        return PersistenceController.shared.container.viewContext
    }

    static func saveContext() {
        PersistenceController.shared.save()
    }


    static func add(name: String, priority: Priority) throws {
        guard !name.isEmpty else {
            throw DataErrors.taskFieldIsEmpry
        }
        
        let task = TaskEntity(context: Self.viewContext)
        task.name = name
        task.priority = priority
        task.isDone = false
        task.createDate = Date()
        
        Self.saveContext()
    }

    func edit(name: String, priority: Priority) throws {
        guard !name.isEmpty else {
            throw DataErrors.taskFieldIsEmpry
        }
        
        self.name = name
        self.priority = priority
        
        Self.saveContext()
    }


    func delete() {
        Self.viewContext.delete(self)
        Self.saveContext()
    }

    func toggleIsDone() {
        self.isDone.toggle()
        if self.isDone {
            self.doneDate = Date()
        } else {
            self.doneDate = nil
            self.createDate = Date()
        }
        Self.saveContext()
    }

}

extension TaskEntity : Identifiable {

}
