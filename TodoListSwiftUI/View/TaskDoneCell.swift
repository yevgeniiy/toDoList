//
//  TaskDoneCell.swift
//  TodoListSwiftUI
//
//  Created by Yevgenii Kryzhanivskyi on 15.08.2022.
//

import SwiftUI

struct TaskDoneCell: View {
    
    var task: TaskEntity
    
    var body: some View {
        HStack {
            Text(task.name)
                .foregroundColor(Color.gray)
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
                .opacity(0.5)
            
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
                Label("Undone", systemImage: "xmark")
            }.tint(.blue)
        }
    }
}


struct TaskDoneCell_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.shared.container.viewContext
        let task = TaskEntity(context: context)
        task.name = "Watch the movie"
        task.priority = .high
        task.isDone = true
        
        return TaskDoneCell(task: task).previewLayout(.sizeThatFits).padding()
    }
}
