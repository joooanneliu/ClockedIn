//
//  StopwatchView.swift
//  ClockedIn
//

import SwiftUI


struct StopwatchView: View {
    
    @ObservedObject var managerClass = ManagerClass()
    @ObservedObject var todoModel = TodoModel.shared
    @State private var timerStart:Bool = false
    @State private var timerRunning:Bool = false
    
    // env variable to control pop-up
    @Environment(\.presentationMode) var addMode
    
    var task:TaskModel
    
    var body: some View {
        NavigationStack{
            HStack{
                Spacer()
                Text(getFormattedTime())
                    .padding(.horizontal, 20)
                    .fontWeight(.semibold)
                    .foregroundColor(Color("DarkBlue"))
            }.padding(.top, 5)
            VStack{
                Text(managerClass.formattedTime)
                    .font(.system(size: 70))
                    .padding(.top, 20)
                    .bold()
                    .foregroundColor(Color("DarkBlue"))
                switch managerClass.mode {
                case .stopped:
                    // adds play button, time reset to 0.0
                    withAnimation{
                        Button(action: {
                            managerClass.start()
                            timerStart = true
                            todoModel.addStartTime(for: task.id)
                            timerRunning = true
                        }, label: {
                            Image("clock-resume")
                                .resizable()
                                .frame(width: 100, height: 100)
                        })
                    }
                case .running:
                    // when running, add pause
                    withAnimation{
                        Button(action: {
                            managerClass.pause()
                            todoModel.addEndTime(for: task.id)
                            timerRunning = false
                        }, label: {
                            Image("clock-pause")
                                .resizable()
                                .frame(width: 100, height: 100)
                        })
                    }
                case .paused:
                    // when paused, add resume
                    withAnimation{
                        Button(action: {
                            managerClass.start()
                            todoModel.addStartTime(for: task.id)
                            timerRunning = true
                        } , label: {
                            Image("clock-resume")
                                .resizable()
                                .frame(width: 100, height: 100)
                        })
                    }
                    
                }
                Spacer()
                
                HStack {
                    Text("Currently on: ")
                    Text(task.name)
                        .cornerRadius(75)
                        .fontWeight(.black)
                        .foregroundColor(.white)
                        .padding(.vertical)
                        .padding(.horizontal, 20)
                        .background(
                            RoundedRectangle(cornerRadius: 75)
                                .fill(Color("PalePink"))
                        )
                }
                
                Spacer()
                
                withAnimation{
                    Button(action: {
                        managerClass.stop()
                        timerStart = false
                        todoModel.removeTask(task)
                    }, label: {
                        Text("Complete Task")
                            .font(.largeTitle)
                            .fontWeight(.black)
                            .foregroundColor(.white)
                            .padding(.vertical)
                            .padding(.horizontal, 40)
                            .background(Color("DarkBlue"))
                            .cornerRadius(75)
                    }).padding(.bottom, 20)
                        .disabled(!timerStart)
                        .opacity(timerStart ? 1.0 : 0.0)
                }
                
                withAnimation{
                    Button(action: {
                        managerClass.stop()
                        timerStart = false
                        todoModel.addEndTime(for: task.id)
                        addMode.wrappedValue.dismiss() // Dismiss the StopwatchView
                    }, label: {
                        Text("End Session")
                            .font(.largeTitle)
                            .fontWeight(.black)
                            .foregroundColor(.white)
                            .padding(.vertical)
                            .padding(.horizontal, 40)
                            .background(Color("DarkBlue"))
                            .cornerRadius(75)
                    }).padding(.bottom, 20)
                        .disabled(!timerStart && timerRunning)
                        .opacity(timerStart ? 1.0 : 0.0)
                        .opacity(timerRunning ? 0.5 : 1.0)
                }
                
                // Button for if user wants to go back to stopwatchList before stopwatch starts
                withAnimation{
                    Button(action: {
                        managerClass.stop()
                        timerStart = false
                        addMode.wrappedValue.dismiss() // Dismiss the StopwatchView
                    }, label: {
                        Text("Back")
                            .font(.largeTitle)
                            .fontWeight(.black)
                            .foregroundColor(.white)
                            .padding(.vertical)
                            .padding(.horizontal, 40)
                            .background(Color("DarkBlue"))
                            .cornerRadius(75)
                    }).padding(.bottom, 20)
                        .disabled(timerStart)
                        .opacity(timerStart ? 0.0 : 1.0)
                }
                
            } // end of VStack
        }
        .onDisappear{
            managerClass.mode = .stopped
            timerStart = false
        }
    }
}
enum mode {
    case running
    case stopped
    case paused
}

class ManagerClass: ObservableObject {
    @Published var secondElapsed = 0.0
    @Published var mode: mode = .stopped
    @Published var timer = Timer()

    var formattedTime: String {
        let hours = Int(secondElapsed) / 3600
        let minutes = Int(secondElapsed) / 60 % 60
        let seconds = Int(secondElapsed) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }

    func start() {
        mode = .running
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            self.secondElapsed += 0.1
        }
    }

    func stop() {
        timer.invalidate()
        secondElapsed = 0
        mode = .stopped
    }

    func pause() {
        timer.invalidate()
        mode = .paused
    }
}

    
struct StopwatchView_Previews: PreviewProvider {
    static var previews: some View {
        StopwatchView(task: ClockedIn.TaskModel(name: "testing", category: "Personal", id: "ab"))
    }
}


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
