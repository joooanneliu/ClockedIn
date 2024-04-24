//
//  StopwatchView.swift
//  MyRev-App
//

import SwiftUI

struct StopwatchView: View {
    
    @ObservedObject var managerClass = ManagerClass()
    @ObservedObject var todoModel = TodoModel()
    
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
                        Button(action: {managerClass.start()}, label: {
                            Image("clock-resume")
                        })
                    }
                case .running:
                    // adds stop and pause button
                    withAnimation{
                        Button(action: {
                            managerClass.pause()
                        }, label: {
                            Image("clock-pause")
                        })
                    }
                case .paused:
                    // adds resume button
                    withAnimation{
                        Button(action: {managerClass.start()}, label: {
                            Image("clock-resume")
                        })
                    }
                    
                }
                Spacer()
                VStack {
                    // Access todoModel.arr here
                    ForEach(todoModel.arr.indices, id: \.self) { index in
                        Text(todoModel.arr[index])
                    }
                }
                withAnimation{
                    Button(action: {
                        managerClass.stop()
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
                }
                
            } // end of VStack
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
        StopwatchView()
    }
}

func getFormattedTime() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "h:mm a"
    return formatter.string(from: Date())
}
