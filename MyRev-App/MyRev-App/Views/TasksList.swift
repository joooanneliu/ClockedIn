//
//  Tasks.swift
//  MyRev-App
//
//  Created by Joanne Liu on 4/24/24.
//

import SwiftUI

struct TasksList: View {
    var tasks: [Tasks]
        
        var body: some View {
            List(tasks) { task in
                VStack(alignment: .leading) {
                    Text(task.name)
                        .font(.headline)
                    Text("Category: \(task.category.rawValue)")
                        .font(.subheadline)
                }
            }
        }
}

#Preview {
    TasksList(tasks: [
        Tasks(id: UUID(), name: "Task 1", category: .personal),
        Tasks(id: UUID(), name: "Task 2", category: .school),
        Tasks(id: UUID(), name: "Task 3", category: .work)
    ])
}
