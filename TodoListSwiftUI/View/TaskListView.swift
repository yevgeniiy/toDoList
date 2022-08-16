//
//  TaskListView.swift
//  TodoListSwiftUI
//
//  Created by Yevgenii Kryzhanivskyi on 16.08.2022.
//

import SwiftUI
import CoreData

struct TaskListView: View {
    
    var tasks: FetchedResults<TaskEntity>
    
    private var completedTasks: [TaskEntity] { return tasks.filter { $0.isDone == true}}
    private var uncompletedTasks: [TaskEntity] { return tasks.filter { $0.isDone == false }}
    
    var body: some View {
        if uncompletedTasks.count > 0 {
            Section {
                ForEach(uncompletedTasks, id: \.self) { task in
                    TaskCell(task: task)
                }
            }
        }
        if completedTasks.count > 0 {
            Section("Done") {
                ForEach(completedTasks, id: \.self) { task in
                    TaskDoneCell(task: task)
                }
            }
        }
    }
}
