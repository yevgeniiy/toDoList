//
//  AddTask.swift
//  TodoListSwiftUI
//
//  Created by Yevgenii Kryzhanivskyi on 16.04.2022.
//

import SwiftUI

struct NewTaskView: View {
    
    //MARK: - PARAMETERS
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    @State var taskField: String = ""
    @State var priority: String = "Normal"
    
    @State private var errorShowing: Bool = false
    @State private var errorTitle: String = ""
    @State private var errorMessage: String = ""
    
    
    var body: some View {
        
        //MARK: - NAVIGATION VIEW
        NavigationView {
            VStack(alignment: .leading, spacing: 15.0) {
                TextField(
                    "Enter your task..",
                    text: $taskField
                ).padding()
                    .background(Color(UIColor.tertiarySystemFill))
                    .cornerRadius(5)
                Text("Priority")
                    .font(.subheadline)
                    .padding(.bottom, -10.0)
                    Picker("Priority", selection: $priority) {
                        ForEach(priorities.reversed(), id: \.self) {
                            Text($0)
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                

                Divider()
                Button(action: saveTask) {
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
            .navigationBarTitle("New todo", displayMode: .inline)
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
    
    private func saveTask() {
        if self.taskField != "" {
            let tasks = Tasks(context: viewContext)
            tasks.name = self.taskField
            tasks.priority = self.priority
            tasks.isDone = false
            tasks.createDate = Date()
            
            saveContext()
            
            self.presentationMode.wrappedValue.dismiss()
        } else {
            self.errorShowing = true
            self.errorTitle = "Invalid Name"
            self.errorMessage = "Make sure to enter something for\nthe new todo item."
            return
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
}

struct TaskView_Previews: PreviewProvider {
    static var previews: some View {
        NewTaskView()
    }
}
