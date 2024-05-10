//
//  InsightView.swift
//  ClockedIn
//

import SwiftUI
import FirebaseFirestore

struct SummaryView: View {
    
    @State private var selectedDate = Date()
    @ObservedObject var todoModel = TodoModel.shared
    @State private var isToday = false
    @State private var isAfterToday = true
    @State private var isCalendarVisible = false

    var body: some View {
        VStack {
            // select date bar
            HStack {
                Button(action: {
                    selectedDate = Calendar.current.date(byAdding: .day, value: -1, to: selectedDate) ?? Date()
                }) {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 20))
                }
                .padding()
                
                Spacer()
                
                Button(action: {
                    isCalendarVisible.toggle()
                }) {
                    Image(systemName: "calendar")
                        .font(.system(size: 25))
                }
                .padding()
                .popover(isPresented: $isCalendarVisible, attachmentAnchor: .point(.bottom), content: {
                    CalendarPopOver(selectedDate: $selectedDate, isCalendarVisible: $isCalendarVisible)
                        .presentationCompactAdaptation(.popover)
                        .frame(width: 350)
                })
                
                Text("\(selectedDate, formatter: dateFormatter)") .font(.system(size: 20))
                
                Spacer()
                
                Button(action: {
                    selectedDate = Calendar.current.date(byAdding: .day, value: 1, to: selectedDate) ?? Date()
                }) {
                    Image(systemName: "arrow.right")
                        .font(.system(size: 20))
                }
                .padding()
            } // end of HStack
            ScrollView {
                LazyVStack {
                    VStack(spacing: 10) {
                        HStack {
                            Text("Summary")
                                .font(.system(size: 45, weight: .medium))
                            Spacer()
                        }
                        
                        Spacer()
                        
                        let sortedTimes = todoModel.sortedStartEndTimes(forDate: selectedDate)
                        ForEach(sortedTimes, id: \.self) { timePair in
                            let task = todoModel.getTask(for: timePair.startTime)
                            VStack(alignment: .leading) {
                                Text("\(task.taskName)")
                                    .fontWeight(.medium)
                                    .font(.system(size: 25))
                                Text("start/end time: \(todoModel.formattedTime(timePair.startTime)) -  \(todoModel.formattedTime(timePair.endTime))")
                                    .fontWeight(.medium)
                                    .font(.system(size: 16))
                                Text("duration: \(todoModel.getDuration( timePair.startTime).formatted())")
                                Text("total time spent so far: \(todoModel.totalTime(for: timePair.startTime).formatted())")
                            }
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 350, height: self.getHeight( timePair.startTime))
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(getBackgroundColor(for: task.category))
                                
                            )
                        }
                        
                        if sortedTimes.isEmpty {
                            Text("No data available")
                                .foregroundColor(.black)
                                .font(.system(size: 20))
                                .padding()
                            Image("clock-sad")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 150, height: 150)
                        }
                        
                    } // end of VStack
                    .padding(20)
                }
            } // end of scroll view
            Spacer()
        }.onAppear{
            selectedDate = Date()
        }
    }
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
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
    

    func getHeight(_ startTime: Timestamp)-> CGFloat {
        
        let duration:TimeInterval = todoModel.getDuration(startTime)
        
        // any instance less than 15 minutes will be set to minHeight
        let minHeight: CGFloat = 150
        let scaleFactor: CGFloat = 10
        
        // every 15 minutes more, increase height by 5
        let scaledHeight = round((CGFloat(duration) - 900) / 900) * scaleFactor
        
        let height = minHeight + scaledHeight
        
        return max(height, scaledHeight)
    }
}

struct CalendarPopOver: View {
    @Binding var selectedDate: Date
    @Binding var isCalendarVisible: Bool
    
    var body: some View {
        VStack {
            DatePicker("", selection: $selectedDate, displayedComponents: [.date])
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding(.horizontal)
                .onChange(of: selectedDate) {
                    isCalendarVisible = false
                }
                
        }
        .padding()
    }
}

extension TimeInterval {
    func formatted() -> String {
        let hours = Int(self) / 3600
        let minutes = (Int(self) % 3600) / 60
        let seconds = (Int(self) % 3600) % 60
        
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}

#Preview {
    SummaryView()
}
