//
//  taskDoneCell.swift
//  TodoListSwiftUI
//
//  Created by Yevgenii Kryzhanivskyi on 19.04.2022.
//

import SwiftUI

struct TaskCell: View {
    
    var task: Tasks
    var tapAction:() -> Void
    
    var body: some View {
        Button {
            tapAction()
        } label: {
            HStack {
                
                Text(task.name ?? "")
                    .foregroundColor(Color.black)
                
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
}

struct TaskCell_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.shared.container.viewContext
        let tasks = Tasks(context: context)
        
        return TaskCell(task: tasks, tapAction: {
            
        }).environment(\.managedObjectContext, context)
    }
}
