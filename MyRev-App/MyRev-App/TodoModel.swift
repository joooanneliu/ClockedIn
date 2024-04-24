import SwiftUI

class TodoModel: ObservableObject {
    static let shared = TodoModel()

    @Published var arr: [task] = []
    
    func addTask(_ newTask: task) {
        arr.append(newTask)
    }
    
    func removeTask(at index: Int) {
        arr.remove(at: index)
    }
}

struct task {
    var name:String
    var category:String
    
    init(name: String, category: String) {
        self.name = name
        self.category = category
    }
}
