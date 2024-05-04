import SwiftUI
import FirebaseFirestore

let db = Firestore.firestore()

class TodoModel: ObservableObject {
    static let shared = TodoModel()

    @Published var arr: [TaskModel] = []
    
    
    func addTask(_ newTask: TaskModel) {
        let taskID = UUID().uuidString
        
        var newTask = newTask
        newTask.id = taskID
        
        // arr.append(newTask)
        
        db.collection("Tasks").document(taskID).setData([
            "taskName": newTask.name,
            "category": newTask.category,
            "active": true
        ]) { err in
            if let err = err {
                print("Error adding task: \(err)")
            } else {
                print("Task added with ID: \(taskID)")
            }
        }
        
        // Add entry in the "stopwatchTimes" collection
        db.collection("StopwatchTimes").document(taskID).setData([
            "completed": false,
            "startTime": [], // empty timestamp for now
            "endTime": [] // empty timestamp for now
        ]) { err in
            if let err = err {
                print("Error adding stopwatch time: \(err)")
            } else {
                print("Stopwatch time added with ID: \(taskID)")
            }
        }
    }
    
    
    func removeTask(_ task: TaskModel) {
        // Remove the task from the database
        
        // Remove from "Tasks" collection
        let db = Firestore.firestore()
        db.collection("Tasks").document(task.id).delete { error in
            if let error = error {
                print("Error removing document: \(error)")
            } else {
                print("Document successfully removed!")
            }
        }

        // Remove the task from the array
        if let index = arr.firstIndex(where: { $0.id == task.id }) {
            arr.remove(at: index)
        }
        
        
        // mark task as complete in "StopwatchTimes" collection
        db.collection("StopwatchTimes").document(task.id).updateData([
            "completed": true
        ]) { error in
            if let error = error {
                print("Error marking complete: \(error)")
            } else {
                print("Task marked complete for: \(task.id)")
            }
        }
    }
    
    func fetchTasks() {
        db.collection("Tasks").getDocuments { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching tasks: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            self.arr = documents.map { queryDocumentSnapshot -> TaskModel in
                let data = queryDocumentSnapshot.data()
                let docID = queryDocumentSnapshot.documentID
                let taskName = data["taskName"] as? String ?? ""
                let category = data["category"] as? String ?? ""
                return TaskModel(name: taskName, category: category, id: docID)
            }
        }
    }
    
    func addStartTime(for taskID: String) {
        // get timestamp for current time
        let startTime = Date()
        
        db.collection("StopwatchTimes").document(taskID).updateData([
            "startTime": FieldValue.arrayUnion([startTime])
        ]) { error in
            if let error = error {
                print("Error adding start time: \(error)")
            } else {
                print("Start time added for task ID: \(taskID)")
            }
        }
    }
    
    
    func addEndTime(for taskID: String) {
        // get timestamp for current time
        let startTime = Date()
        
        db.collection("StopwatchTimes").document(taskID).updateData([
            "endTime": FieldValue.arrayUnion([startTime])
        ]) { error in
            if let error = error {
                print("Error adding end time: \(error)")
            } else {
                print("End time added for task ID: \(taskID)")
            }
        }
    }
}

struct TaskModel: Identifiable {
    var name:String
    var category:String
    var id:String
    
    init(name: String, category: String, id:String) {
        self.name = name
        self.category = category
        self.id = id
    }
}
