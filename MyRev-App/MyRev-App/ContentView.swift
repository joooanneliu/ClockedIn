//import SwiftUI
//
//struct ContentView: View {
//    @State private var tasks: [Tasks] = []
//    @State private var selectedCategory: Category? = nil
//    @State private var showingAddTaskView = false
//    
//    var body: some View {
//        NavigationView {
//            List {
//                ForEach(Category.allCases, id: \.self) { category in
//                    Section(header: Text(category.rawValue)) {
//                        ForEach(tasks.filter { $0.category == category }, id: \.id) { task in
//                            NavigationLink(destination: TaskDetail(tasks: $tasks, task: task)) {
//                                VStack(alignment: .leading) {
//                                    Text(task.name)
//                                    Text("Category: \(task.category.rawValue)")
//                                        .font(.caption)
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//            .navigationTitle("My To-do List")
//            .navigationBarItems(trailing:
//                Button(action: {
//                    showingAddTaskView = true
//                }) {
//                    Image(systemName: "plus")
//                }
//            )
//            .sheet(isPresented: $showingAddTaskView) {
//                AddTaskView(isPresented: $showingAddTaskView, tasks: $tasks)
//            }
//        }
//    }
//}
//
//struct TaskDetail: View {
//    @Binding var tasks: [Tasks]
//    let task: Tasks
//    @State private var isDone = false
//    
//    var body: some View {
//        VStack {
//            Text(task.name)
//                .font(.largeTitle.bold())
//            Text("\(task.category.rawValue)")
//                .font(.caption)
//            Button(action: {
//                isDone.toggle()
//                if isDone {
//                    // Remove the task from the list when marked as done
//                    tasks.removeAll { $0.id == task.id }
//                }
//            }) {
//                Text("Complete")
//            }
//            .foregroundColor(.green)
//            .padding()
//        }
//    }
//}
//
//struct AddTaskView: View {
//    @Binding var isPresented: Bool
//    @Binding var tasks: [Tasks]
//    @State private var taskName = ""
//    @State private var selectedCategory: Category = .personal
//    
//    var body: some View {
//        NavigationView {
//            Form {
//                Section(header: Text("New Task")) {
//                    TextField("Task Name", text: $taskName)
//                    Picker("Category", selection: $selectedCategory) {
//                        ForEach(Category.allCases, id: \.self) { category in
//                            Text(category.rawValue)
//                        }
//                    }
//                    .pickerStyle(MenuPickerStyle())
//                }
//                
//                Button(action: {
//                    // Add the new task
//                    if !taskName.isEmpty {
//                        tasks.append(Tasks(id: UUID(), name: taskName, category: selectedCategory))
//                        isPresented = false // Dismiss the AddTaskView
//                    }
//                }) {
//                    Text("Add Task")
//                }
//            }
//            .navigationTitle("Add New Task")
//        }
//    }
//}
//
//struct Tasks: Identifiable {
//    var id: UUID
//    let name: String
//    let category: Category
//}
//
//enum Category: String, CaseIterable {
//    case personal = "Personal"
//    case school = "School"
//    case work = "Work"
//}
//
//#Preview {
//    ContentView()
//}

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            TodoView()
                .tabItem {
                    Image(systemName: "list.clipboard")
                    Text("To-do")
                }
            StopwatchView()
                .tabItem {
                    Image(systemName: "clock")
                    Text("Stopwatch")
                }
            InsightView()
                .tabItem {
                    Image(systemName: "lightbulb")
                    Text("Insight")
                }
        }
    }
}

#Preview {
    ContentView()
}
