//
//  AddTask.swift
//  TodoListSwiftUI
//
//  Created by Yevgenii Kryzhanivskyi on 16.04.2022.
//

import SwiftUI

struct EditTaskView: View {
    
    //MARK: - PARAMETERS
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var tasks: Tasks
    
    @State public var taskName: String = ""
    @State public var taskPriority: String = ""
    @State public var taskId: UUID
    
    @State private var errorShowing: Bool = false
    @State private var errorTitle: String = ""
    @State private var errorMessage: String = ""
    
    
    init(taskObject: Tasks) {
        self.tasks = taskObject
        self._taskName = State(initialValue: taskObject.name ?? "Unknown")
        self._taskId = State(initialValue: taskObject.id ?? UUID())
        self._taskPriority = State(initialValue: taskObject.priority ?? "Normal")
    }
    
    var body: some View {
        
        //MARK: - NAVIGATION VIEW
        
        NavigationView {
            VStack(alignment: .leading, spacing: 15.0) {
                TextField(
                    "Enter your task..",
                    text: $taskName
                ).padding()
                    .background(Color(UIColor.tertiarySystemFill))
                    .cornerRadius(5)
                Text("Priority")
                    .font(.subheadline)
                    .padding(.bottom, -10.0)
                Picker("Priority", selection: $taskPriority) {
                    ForEach(priorities.reversed(), id: \.self) {
                            Text($0)
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                

                Divider()
                Button(action: saveEditedTask) {
                    Text("Save")
                        .font(.system(size: 24, weight: .bold, design: .default))
                        .padding()
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .background(Color.cyan)
                        .cornerRadius(5)
                        .foregroundColor(Color.white)
                }
                Spacer()
            }
            .padding(.horizontal)
            .padding(.vertical, 30)
            .navigationBarTitle("Edit task", displayMode: .inline)
            .navigationBarItems(trailing:
              Button(action: {
                self.presentationMode.wrappedValue.dismiss()
              }) {
                Image(systemName: "xmark")
              })
            .alert(isPresented: $errorShowing) {
              Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
          }
            
        } //: - NAVIGATION VIEW
    }
    
    //MARK: - FUNCTIONS
    
    private func saveEditedTask() {
        if self.taskName != "" {
            let task = self.tasks
            task.id = self.taskId
            task.name = self.taskName
            task.priority = self.taskPriority
            task.isDone = false

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
            self.presentationMode.wrappedValue.dismiss()
        } else {
            self.errorShowing = true
            self.errorTitle = "Invalid Name"
            self.errorMessage = "Make sure to enter something for\nthe new todo item."
            return
        }
        
    }
}

struct EditTaskView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.shared.container.viewContext
        let tasks = Tasks(context: context)
        tasks.name = "Test 1"
        tasks.priority = "High"
        
        return EditTaskView(taskObject: tasks).environment(\.managedObjectContext, context)
        
    }
}

