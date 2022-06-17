//
//  ContentView.swift
//  TodoListSwiftUI
//
//  Created by Yevgenii Kryzhanivskyi on 16.04.2022.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @State private var showAddTaskView: Bool = false
    @State private var selectedTask: Tasks? = nil
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var presentationMode
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Tasks.createDate, ascending: false)],
        predicate: NSPredicate(format: "isDone == false"),
        animation: .default) private var tasks: FetchedResults<Tasks>
    
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Tasks.doneDate, ascending: false)],
        predicate: NSPredicate(format: "isDone == true"),
        animation: .default) private var tasksIsDone: FetchedResults<Tasks>
    
    var body: some View {
        NavigationView {
            
            List {
                // MARK: - TASKS
                Section {
                    if tasks.count == 0 {
                        Text("No task to show")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    } else {
                        ForEach(self.tasks, id: \.self) { task in
                            
                            TaskCell(task: task, tapAction: {
                                self.selectedTask = task
                            })
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button (role: .destructive) {
                                        deleteItem(task: task)
                                    } label: {
                                        Label("Delete", systemImage: "trash.fill")
                                    }
                                }
                                .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                    Button {
                                        toggleTaskIsDone(task: task)
                                    } label: {
                                        Label("Done", systemImage: "checkmark")
                                    }.tint(.green)
                                }
                            //: SwipeActions
                        }
                    }
                    
                    
                } //:Tasks
                
                //MARK: - COMPLETED TASKS
                if tasksIsDone.count > 0 {
                    Section(header: Text("Done")) {
                        ForEach(self.tasksIsDone, id: \.self) { task in
                            
                            TaskDoneCell(task: task)
                            
                            // SwipeActions
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button (role: .destructive) {
                                        deleteItem(task: task)
                                    } label: {
                                        Label("Delete", systemImage: "trash.fill")
                                    }
                                }
                                .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                    Button {
                                        toggleTaskIsDone(task: task)
                                    } label: {
                                        Label("Undone", systemImage: "xmark")
                                    }.tint(.blue)
                                } //: SwipeActions
                            
                        }
                        
                    }
                    
                }
                //: - COMPLETED TASKS
            }
            
            .navigationBarTitle(Text("To do"))
            .navigationBarTitleDisplayMode(.inline)
            
            // MARK: - TOOLBAR
            .toolbar {
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Menu("Priority") {
                        Button("All", action: {
                            filterPriority()
                        })
                        ForEach(priorities, id: \.self) { priority in
                            Button("\(priority)", action: {
                                filterPriority(priority: priority)
                            })
                        }
                    }
                }
                
                ToolbarItem {
                    Button(action: {
                        self.showAddTaskView.toggle()
                    }) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            //: Toolbar
            
            //MARK: - SHEET
            
            .sheet(isPresented: $showAddTaskView) {
                NewTaskView()
            }
            .sheet(item: self.$selectedTask) { selectedTask in
                EditTaskView(taskObject: selectedTask)
            }
        }
    }
    
    
    // MARK: - FUNCTIONS
    
    private func deleteItem(task: Tasks) {
        withAnimation {
            viewContext.delete(task)
            saveContext()
        }
    }
    
    private func toggleTaskIsDone(task: Tasks) {
        withAnimation {
            task.isDone.toggle()
            if task.isDone {
                task.doneDate = Date()
            } else {
                task.doneDate = nil
                task.createDate = Date()
            }
            saveContext()
        }
    }
    
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    private func filterPriority(priority:String? = nil) {
        if priority == nil {
            tasks.nsPredicate = NSPredicate(format: "isDone == false")
            tasksIsDone.nsPredicate = NSPredicate(format: "isDone == true")
            
        } else {
            tasks.nsPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [NSPredicate(format: "isDone == false"), NSPredicate(format: "priority == %@", priority!)])
            
            tasksIsDone.nsPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [NSPredicate(format: "isDone == true"), NSPredicate(format: "priority == %@", priority!)])
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.shared.container.viewContext
        return ContentView().environment(\.managedObjectContext, context)
    }
}
