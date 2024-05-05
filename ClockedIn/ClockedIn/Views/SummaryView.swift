//
//  InsightView.swift
//  ClockedIn
//

import SwiftUI

struct SummaryView: View {
    
    @State private var selectedDate = Date()
    @ObservedObject var todoModel = TodoModel.shared
    @State private var isToday = false

    var body: some View {
        VStack {
            // select date bar
            HStack {
                Button(action: {
                    selectedDate = Calendar.current.date(byAdding: .day, value: -1, to: selectedDate) ?? Date()
                    //todoModel.fetchData(for: selectedDate)
                    updateTodayStatus()
                }) {
                    Image(systemName: "arrow.left")
                }
                .padding()
                
                Spacer()
                
                Text("\(selectedDate, formatter: dateFormatter)")
                
                Spacer()
                
                Button(action: {
                    selectedDate = Calendar.current.date(byAdding: .day, value: 1, to: selectedDate) ?? Date()
                    // todoModel.fetchData(for: selectedDate)
                    updateTodayStatus()
                }) {
                    Image(systemName: "arrow.right")
                        .opacity(isToday ? 0.5 : 1.0)
                        .disabled(isToday)
                }
                .padding()
            } // end HStack
            ScrollView {
                LazyVStack {
                    VStack(spacing: 10) {
                        HStack {
                            Text("Summary")
                                .font(.system(size: 45, weight: .medium))
                            Spacer()
                        }
                        
                        Spacer()
                        ForEach(todoModel.sortedStartEndTimes(forDate: selectedDate), id: \.self) { timePair in
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
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(getBackgroundColor(for: task.category))
                            )
                        }
                    } // end of VStack
                    .padding(20)
                }
            } // end of scroll view
            Spacer()
        }.onAppear{
            selectedDate = Date()
            updateTodayStatus()
        }
    }
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }
        
    func updateTodayStatus() {
        isToday = Calendar.current.isDate(selectedDate, inSameDayAs: Date())
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
