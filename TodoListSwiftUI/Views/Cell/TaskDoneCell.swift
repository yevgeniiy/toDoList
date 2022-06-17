//
//  taskDoneCell.swift
//  TodoListSwiftUI
//
//  Created by Yevgenii Kryzhanivskyi on 19.04.2022.
//

import SwiftUI

struct TaskDoneCell: View {
    
    var task: Tasks
    
    var body: some View {
        HStack {
            Text(task.name ?? "")
                .strikethrough(task.isDone)
                .opacity(0.5)
            
            Spacer()
            
            Text(task.priority ?? "")
                .font(.footnote)
                .foregroundColor(colorPriority(priority: task.priority ?? "Normal"))
                .padding(3)
                .frame(minWidth: 62)
                .overlay(
                    Capsule().stroke(colorPriority(priority: task.priority ?? "Normal"), lineWidth: 0.75)
                )
        }
    }
}

struct TaskDoneCell_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.shared.container.viewContext
        let tasks = Tasks(context: context)
        
        return TaskDoneCell(task: tasks).environment(\.managedObjectContext, context)
    }
}
