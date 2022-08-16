//
//  AddTask.swift
//  TodoListSwiftUI
//
//  Created by Yevgenii Kryzhanivskyi on 16.04.2022.
//

import SwiftUI

struct EditTaskView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var task: TaskEntity
    
    @State var showError = false
    @State var errorMessage: String = "Unknown error"
    
    @State public var taskName: String
    @State public var priority: Priority
    
    init(taskObject: TaskEntity) {
        self.task = taskObject
        self._taskName = State(initialValue: taskObject.name)
        self._priority = State(initialValue: taskObject.priority)
    }
    
    var body: some View {
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
                Picker("Priority", selection: $priority) {
                    ForEach(Priority.allCases, id: \.self) { priority in
                        Text(priority.name)
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
                                    Button(action: closeView) {
                Image(systemName: "xmark")
            })
            .alert(errorMessage, isPresented: $showError) {
                Button("Ok", role: .cancel) {}
            }
        }
    }
}

struct EditTaskView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.shared.container.viewContext
        let task = TaskEntity(context: context)
        task.name = "Watch the movie"
        task.priority = .high
        
        return EditTaskView(taskObject: task)
        
    }
}

//MARK: - ACTIONS

extension EditTaskView {
    
    private func saveEditedTask() {
        do {
            try self.task.edit(name: taskName, priority: self.priority)
            closeView()
        } catch {
            showError(error)
        }
    }
    
    private func showError(_ error: Error) {
        self.showError = true
        self.errorMessage = error.localizedDescription
    }
    
    private func closeView() {
        self.presentationMode.wrappedValue.dismiss()
    }
    
}

