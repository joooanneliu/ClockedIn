//
//  StopwatchListView.swift
//  ClockedIn
//
//  Created by Joanne Liu on 5/3/24.
//

import SwiftUI

struct StopwatchListView: View {
    
    @ObservedObject var todoModel = TodoModel.shared
    @State private var selectedTask: TaskModel?
    @State private var showNewTaskView = false
    
    var body: some View {
        NavigationView {
            
            VStack(spacing: 0) {
                HStack{
                    Spacer()
                    Text(getFormattedTime())
                        .padding(.horizontal, 20)
                        .fontWeight(.semibold)
                        .foregroundColor(Color("DarkBlue"))
                }.padding(.top, 5)
                ZStack {
                    Rectangle()
                        .foregroundColor(Color("DarkBlue"))
                        .frame(height: 60) // Set height dynamically
                        .cornerRadius(1)
                    
                    HStack {
                        Image("clock")
                        Text(getFormattedDate())
                            .padding(.horizontal, 8)
                            .font(.largeTitle)
                            .fontWeight(.black)
                            .foregroundColor(.white)
                    }
                    
                }.padding(.top, -40)
                
                Text("select task:")
                    .padding(.top, 20)
                VStack(spacing: 16) {
                    ForEach(todoModel.arr) { task in
                        Button(action: {
                            selectedTask = task
                        }) {
                            HStack {
                                Text(task.name)
                                Spacer()
                                Image(systemName: "arrow.forward")
                            }
                            .frame(maxWidth: .infinity)
                            .cornerRadius(75)
                            .fontWeight(.black)
                            .foregroundColor(.white)
                            .padding(.vertical)
                            .padding(.horizontal, 40)
                            .background(
                                RoundedRectangle(cornerRadius: 75)
                                    .fill(getBackgroundColor(for: task.category))
                            )
                        }
                    }
                }
                .padding(30)
                .onReceive(NotificationCenter.default.publisher(for: Notification.Name("dismissNewTaskView"))) { _ in
                    // Fetch tasks when NewTaskView is dismissed
                    todoModel.fetchTasks()
                }
                .sheet(item: $selectedTask) { task in
                    StopwatchView(task: task)
                }
                .onAppear {
                    todoModel.fetchTasks()
                }
        
                Button(action: {
                    showNewTaskView = true // Present NewTask view
                }) {
                    Image("clock-add")
                }
                .sheet(isPresented: $showNewTaskView) {
                    NewTask(isPresented: $showNewTaskView) // Pass binding to control pop up
                }
                .padding(.bottom, 20)
                
                Spacer()
            }
        }
    }
    
    func getBackgroundColor(for category: String) -> Color {
        switch category {
        case "School":
            return Color("PalePink")
        case "Personal":
            return Color("LightGreen")
        case "Work":
            return Color("LightBlue")
        default:
            return Color.gray
        }
    }
}

#Preview {
    StopwatchListView()
}
