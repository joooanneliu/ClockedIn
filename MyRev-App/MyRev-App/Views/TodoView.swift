import SwiftUI

struct TodoView: View {
    @State private var tasks: [Tasks] = []
    @State private var selectedCategory: Category? = nil
    @State private var showingAddTaskView = false
    
    func getFormattedDate() -> String {
        let formatter = DateFormatter()
        // formats the date so it is month/date, weekday
        formatter.dateFormat = "M/d, EE"
        return formatter.string(from: Date())
    }
    
    func getFormattedTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: Date())
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack{
                Spacer()
                Text(getFormattedTime())
                    .padding(.horizontal, 20)
                    .fontWeight(.semibold)
                    .foregroundColor(Color("DarkBlue"))
            }.padding(.top, 5)
            ZStack {
                GeometryReader { geometry in
                    Rectangle()
                        .foregroundColor(Color("DarkBlue"))
                        .frame(height: 60) // Set height dynamically
                        .cornerRadius(1)
                        .offset(y: geometry.size.height / 7)
                    
                    HStack {
                        Image("clock")
                        Text(getFormattedDate())
                            .padding(.horizontal, 8)
                            .font(.largeTitle)
                            .fontWeight(.black) // .black is also a thickness
                            .foregroundColor(.white)
                    }
                }
            }.padding(.top, -40)
            
            NavigationView {
                List {
                    ForEach(Category.allCases, id: \.self) { category in
                        Section(header: Text(category.rawValue)) {
                            ForEach(tasks.filter { $0.category == category }, id: \.id) { task in
                                NavigationLink(destination: TaskDetail(tasks: $tasks, task: task)) {
                                    VStack(alignment: .leading) {
                                        Text(task.name)
                                        Text("Category: \(task.category.rawValue)")
                                            .font(.caption)
                                    }
                                }
                            }
                        }
                    }
                }
                .navigationTitle("My To-do List")
                .navigationBarItems(trailing:
                                        Button(action: {
                    showingAddTaskView = true
                }) {
                    Image(systemName: "plus")
                }
                )
                .sheet(isPresented: $showingAddTaskView) {
                    AddTaskView(isPresented: $showingAddTaskView, tasks: $tasks)
                }
            } // end of navigation view
        }
    }
}

struct TaskDetail: View {
    @Binding var tasks: [Tasks]
    let task: Tasks
    @State private var isDone = false
    
    var body: some View {
        VStack {
            Text(task.name)
                .font(.largeTitle.bold())
            Text("\(task.category.rawValue)")
                .font(.caption)
            Button(action: {
                isDone.toggle()
                if isDone {
                    // Remove the task from the list when marked as done
                    tasks.removeAll { $0.id == task.id }
                }
            }) {
                Text("Complete")
            }
            .foregroundColor(.green)
            .padding()
        }
    }
}

struct AddTaskView: View {
    @Binding var isPresented: Bool
    @Binding var tasks: [Tasks]
    @State private var taskName = ""
    @State private var selectedCategory: Category = .personal
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("New Task")) {
                    TextField("Task Name", text: $taskName)
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(Category.allCases, id: \.self) { category in
                            Text(category.rawValue)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                
                Button(action: {
                    // Add the new task
                    if !taskName.isEmpty {
                        tasks.append(Tasks(id: UUID(), name: taskName, category: selectedCategory))
                        isPresented = false // Dismiss the AddTaskView
                    }
                }) {
                    Text("Add Task")
                    .navigationBarItems(trailing:
                        Button(action: {
                               isPresented = false // Dismiss the AddTaskView
                           }) {
                               Image(systemName: "xmark")
                           }
                    )
                }
            }
            .navigationTitle("Add New Task")
        }
    }
}

struct Tasks: Identifiable {
    var id: UUID
    let name: String
    let category: Category
}

enum Category: String, CaseIterable {
    case personal = "Personal"
    case school = "School"
    case work = "Work"
}

#Preview {
    TodoView()
}
