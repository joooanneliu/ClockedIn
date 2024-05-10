//
//  Tasks.swift
//  MyRev-App
//
//  Created by Joanne Liu on 4/24/24.
//

import SwiftUI

struct NewTask: View {
    @ObservedObject var todoModel = TodoModel.shared
    @Binding var isPresented: Bool
    @State private var taskName: String = ""
    let categories = ["Personal", "School", "Work"]
    @State private var selectedOption:Int = 0
    // @State private var taskAdded = false
    
    var body: some View {
        NavigationView {
                VStack(spacing: 0) {
                    Spacer()
                    VStack (alignment: .leading){
                        Text("New Task Name:")
                            .bold()
                            .foregroundColor(Color("DarkBlue"))
                        TextField("Task", text: $taskName)
                            .padding(12)
                            .background(Color.white)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 50)
                                    .stroke(Color.black, lineWidth: 1)
                            )
                        Text("Category:")
                            .bold()
                            .foregroundColor(Color("DarkBlue"))
                        
                        Picker(selection: $selectedOption ,label: Text("Options")) {
                            ForEach(categories.indices, id: \.self) { index in
                                Text(self.categories[index])
                                    .tag(index)
                                
                            }
                        }
                        .padding(5)
                        .background(Color.white)
                        .cornerRadius(10)
                        .frame(maxWidth: .infinity)
                        .overlay(
                            RoundedRectangle(cornerRadius: 50)
                                .stroke(Color.black, lineWidth: 1)
                        )
                    }.padding(.horizontal, 40)
                        .padding(.top, 20)
                        .padding(.bottom, 40)
                    Spacer()
                    Button(action: {
                        todoModel.addTask(ClockedIn.TaskModel(name: taskName, category: categories[selectedOption], id: ""))
                        isPresented = false // Dismiss the NewTask view
                        NotificationCenter.default.post(name: Notification.Name("dismissNewTaskView"), object: nil) // Post notification when NewTask view is dismissed
                    }, label: {
                        Text("Add Task")
                            .font(.title)
                            .fontWeight(.black)
                            .foregroundColor(.white)
                            .padding(.vertical)
                            .padding(.horizontal, 40)
                            .background(Color("DarkBlue"))
                            .cornerRadius(75)
                    }).padding(.bottom, 20)
                        .disabled(taskName == "")
                        .opacity(taskName == "" ? 0.5 : 1.0)
                    
                } // end of vstack
            }

    }
}



#Preview {
    NewTask(isPresented: .constant(true))
}
