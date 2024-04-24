import SwiftUI



struct TodoView: View {
    @ObservedObject var todoModel = TodoModel.shared
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
                VStack(spacing: 16) {
                    // Access todoModel.arr here
                    ForEach(todoModel.arr.indices, id: \.self) { index in
                        HStack {
                            Text(todoModel.arr[index].name)
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        .cornerRadius(75)
                        .fontWeight(.black)
                        .foregroundColor(.white)
                        .padding(.vertical)
                        .padding(.horizontal, 40)
                        .background(
                            RoundedRectangle(cornerRadius: 75) // Apply corner radius to the RoundedRectangle
                                .fill(Color("PalePink"))
                        )
                    }
                }.padding(30)
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
            } // end of vstack
            .navigationBarBackButtonHidden(true) // Hide the back button
        }
    }
}

#Preview {
    TodoView()
}
