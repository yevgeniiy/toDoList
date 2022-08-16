//
//  ContentView.swift
//  TodoListSwiftUI
//
//  Created by Yevgenii Kryzhanivskyi on 16.04.2022.
//

import SwiftUI

struct ContentView: View {
    
    @State private var showNewTaskView: Bool = false
    
    @StateObject var errorHandling = ErrorHandling.shared
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \TaskEntity.createDate, ascending: false)]) private var tasks: FetchedResults<TaskEntity>
    
    var body: some View {
        NavigationView {
            List {
                if tasks.count == 0 {
                    EmptyCellView()
                } else {
                    TaskListView(tasks: tasks)
                }
            }
            .navigationBarTitle(Text("To do"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem {
                    Button(action: newTaskView) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Menu("Priority") {
                        Button("All") {
                            tasks.nsPredicate = nil
                        }
                        ForEach(Priority.allCases, id: \.self) { priority in
                            Button("\(priority.name)") {
                                withAnimation {
                                filterByPriority(priority: priority)
                                }
                            }
                        }
                    }
                }
            }
            .alert(errorHandling.localizedError, isPresented: $errorHandling.hasError) {
                Button("Ok") {
                    errorHandling.dismissButton()
                }
            }
            .sheet(isPresented: $showNewTaskView) {
                NewTaskView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        return ContentView().environment(\.managedObjectContext, context)
    }
}

// MARK: - ACTIONS

extension ContentView {
    
    private func newTaskView() {
        self.showNewTaskView = true
    }
    
    private func filterByPriority(priority: Priority) {
        tasks.nsPredicate = NSPredicate(format: "priorityValue == %@", priority.rawValue)
    }
    
}
