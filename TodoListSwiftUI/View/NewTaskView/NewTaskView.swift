//
//  AddTask.swift
//  TodoListSwiftUI
//
//  Created by Yevgenii Kryzhanivskyi on 16.04.2022.
//

import SwiftUI

struct NewTaskView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var showError = false
    @State var errorMessage: String = "Unknown error"
    
    @State var taskField: String = ""
    @State var priority: Priority = .normal
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 15.0) {
                
                TextField("Enter your task..", text: $taskField)
                    .padding()
                    .background(Color(UIColor.tertiarySystemFill))
                    .cornerRadius(5)
                
                Text("Priority")
                    .font(.subheadline)
                    .padding(.bottom, -10.0)
                    Picker("Priority", selection: $priority) {
                        ForEach(Priority.allCases, id: \.self) { priority in
                            Text(priority.name)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                
                Divider()
                
                Button(action: addTask) {
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
              Button(action: closeView) {
                Image(systemName: "xmark")
              })

            
        }
        .alert(errorMessage, isPresented: $showError) {
            Button("Ok", role: .cancel) {}
        }
    }
    

    

}

struct TaskView_Previews: PreviewProvider {
    static var previews: some View {
        NewTaskView()
    }
}

//MARK: - ACTIONS

extension NewTaskView {
    
    private func addTask() {
        do {
            try TaskEntity.add(name: taskField, priority: priority)
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
