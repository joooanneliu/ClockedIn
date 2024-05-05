import SwiftUI
import FirebaseFirestore

let db = Firestore.firestore()

class TodoModel: ObservableObject {
    static let shared = TodoModel()

    @Published var arr: [TaskModel] = []
    @Published var stopwatchTimes = [StopwatchTime]()
    
    func addTask(_ newTask: TaskModel) {
//        print("add task")
//        print()
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
            "endTime": [], // empty timestamp for now
            "taskName": newTask.name,
            "category": newTask.category,
        ]) { err in
            if let err = err {
                print("Error adding stopwatch time: \(err)")
            } else {
                print("Stopwatch time added with ID: \(taskID)")
            }
        }
    }
    
    func removeTask(_ task: TaskModel) {
//        print("remove task")
//        print()
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
//        print("fetch tasks")
//        print()
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
//        print("add start time")
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
        print()
    }
    
    func addEndTime(for taskID: String) {
//        print("add end time")

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
        print()
    }
    
    func fetchData() {
//        print("in fetch data")
//        print()
        db.collection("StopwatchTimes")
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                    return
                } 
                
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
                
                self.stopwatchTimes = documents.map { queryDocumentSnapshot -> StopwatchTime in
                    let data = queryDocumentSnapshot.data()
                    let docID = queryDocumentSnapshot.documentID
                    let startTimeArr = data["startTime"] as? [Timestamp] ?? []
                    let endTimeArr = data["endTime"] as? [Timestamp] ?? []
                    let name = data["taskName"] as? String ?? ""
                    let categ = data["category"] as? String ?? ""
                    let complBool = data["completed"] as? Bool ?? false
                    
                    var totalTime: TimeInterval = 0
                    for (start, end) in zip(startTimeArr, endTimeArr) {
                        totalTime += end.dateValue().timeIntervalSince(start.dateValue())
                    }
                    return StopwatchTime(id: docID, startTime: startTimeArr, endTime: endTimeArr, taskName: name, category: categ, completed: complBool, totalTime: totalTime)
                }
            }
    }
    
    func sortedStartEndTimes(forDate date: Date) -> [TimePair] {
//        print("sorted start end times")
//        print()
        self.fetchData();
        var allTimes: [TimePair] = []
        for stopwatchTime in self.stopwatchTimes {
            let startTimeCount = stopwatchTime.startTime.count
            let endTimeCount = stopwatchTime.endTime.count
            
            // accounts for case when stopwatch is still running -> end time for index doesn't exist
            let minCount = min(startTimeCount, endTimeCount)
            for i in 0..<minCount {
                let startTime = stopwatchTime.startTime[i]
                let endTime = stopwatchTime.endTime[i]
                
                // if start or end time is the same day as date
                if Calendar.current.isDate(startTime.dateValue(), inSameDayAs: date) || Calendar.current.isDate(endTime.dateValue(), inSameDayAs: date) {
                    allTimes.append(TimePair(startTime: startTime, endTime: endTime))
                }
            }
        }
        return allTimes.sorted(by: { $0.startTime.dateValue() < $1.startTime.dateValue() })
    }
    
    
    func endTime(for startTime: Timestamp) -> Timestamp {
//        print("in end time")
        for stopwatchTime in self.stopwatchTimes {
            if let index = stopwatchTime.startTime.firstIndex(of: startTime) {
                return stopwatchTime.endTime[index]
            }
        }
        return Timestamp()
    }
    
    func getTask(for startTime: Timestamp) -> StopwatchTime {
        // print("get task")
        for stopwatchTime in self.stopwatchTimes {
            if stopwatchTime.startTime.contains(startTime) {
                return stopwatchTime
            }
        }
        // Return a default task when no matching task is found - SHOULD NEVER HAPPEN
        return StopwatchTime(id: "", startTime: [], endTime: [], taskName: "", category: "", completed: false, totalTime: 0)
    }
    
    func formattedDate(_ timestamp: Timestamp) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d h:mm a"
            return dateFormatter.string(from: timestamp.dateValue())
        }
        
    func formattedTime(_ timestamp: Timestamp) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter.string(from: timestamp.dateValue())
    }
    
    // returns total time spent on task up til startTime
    func totalTime(for startTime: Timestamp) -> TimeInterval {
        var total:TimeInterval = 0
        for stopwatchTime in self.stopwatchTimes {
            if stopwatchTime.startTime.contains(startTime) {
                for curr in stopwatchTime.startTime {
                    if curr.dateValue() <= startTime.dateValue() {
                        let currEnd = endTime(for: curr)
                        total += currEnd.dateValue().timeIntervalSince(curr.dateValue())
                    } else {
                        break
                    }
                }
                return total
            }
        }
        return total
    }
    
    func getDuration(_ start: Timestamp) -> TimeInterval {
        let end = endTime(for: start)
        if(end != Timestamp()) {
            return end.dateValue().timeIntervalSince(start.dateValue())
        }
        return 0
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

struct StopwatchTime: Identifiable {
    var id: String
    var startTime: [Timestamp]
    var endTime: [Timestamp]
    var taskName:String
    var category:String
    var completed:Bool
    var totalTime: TimeInterval
}

struct TimePair: Hashable {
    let startTime: Timestamp
    let endTime: Timestamp
}
