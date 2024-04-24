import SwiftUI

class TodoModel: ObservableObject {
    @Published var arr: [String] = []
    
    func addTask(_ task: String) {
        arr.append(task)
    }
    
    func removeTask(at index: Int) {
        arr.remove(at: index)
    }
}
