//
//  taskDoneCell.swift
//  TodoListSwiftUI
//
//  Created by Yevgenii Kryzhanivskyi on 19.04.2022.
//

import SwiftUI

struct TaskCell: View {
    
    @ObservedObject var task: TaskEntity
    
    @State private var showEditTaskView = false
    
    var body: some View {
        Button {
            showEditTaskView = true
        } label: {
            HStack {
                Text(task.name)
                    .foregroundColor(Color.black)
                    .strikethrough(task.isDone)
                Spacer()
                Text(task.priority.name)
                    .font(.footnote)
                    .foregroundColor(task.priority.color)
                    .padding(3)
                    .frame(minWidth: 62)
                    .overlay(
                        Capsule().stroke(task.priority.color, lineWidth: 0.75)
                    )
            }
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button (role: .destructive) {
                withAnimation(.easeInOut) {
                    task.delete()
                }
            } label: {
                Label("Delete", systemImage: "trash.fill")
            }
        }
        .swipeActions(edge: .leading, allowsFullSwipe: true) {
            Button {
                withAnimation(.easeInOut) {
                    task.toggleIsDone()
                }
            } label: {
                Label("Done", systemImage: "checkmark")
            }.tint(.green)
        }
        .sheet(isPresented: $showEditTaskView) {
            EditTaskView(taskObject: task)
        }
    }
}

struct TaskCell_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.shared.container.viewContext
        let task = TaskEntity(context: context)
        task.name = "Watch the movie"
        task.priority = .high
        task.isDone = false
        
        return TaskCell(task: task).previewLayout(.sizeThatFits).padding()
    }
}
