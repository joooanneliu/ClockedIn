import SwiftUI
import Firebase

struct Event {
    let title: String
    let startTime: String
    let endTime: String
    let color: Color
}

struct EventBlock: View {
    let event: Event

    var body: some View {
        VStack {
            Text(event.title)
                .padding(5)
                .foregroundColor(.white)
                .background(event.color)
                .cornerRadius(5)
            Text("\(event.startTime) - \(event.endTime)")
                .font(.footnote)
                .foregroundColor(.gray)
        }
    }
}

struct InsightView: View {
    let events = [
        Event(title: "Homework", startTime: "12:30 PM", endTime: "1:30 PM", color: .blue),
        Event(title: "Quiz", startTime: "2:00 PM", endTime: "5:00 PM", color: .pink)
    ]

    let timestamps = Array(stride(from: 0, to: 24, by: 1)).map { "\($0 % 12 == 0 ? 12 : $0 % 12) \($0 < 12 ? "AM" : "PM")" }

    var body: some View {
        HStack {
            VStack(alignment: .trailing, spacing: 10) {
                ForEach(timestamps, id: \.self) { timestamp in
                    Text(timestamp)
                        .frame(width: 60, alignment: .trailing)
                        .foregroundColor(.gray)
                }
            }
            .padding(.trailing)

            GeometryReader { geometry in
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(events, id: \.title) { event in
                        HStack {
                            EventBlock(event: event)
                                .frame(width: geometry.size.width, alignment: .leading)
                                .position(x: self.position(for: event.startTime, in: geometry.size.width))
                        }
                    }
                }
            }
            .padding()
        }
    }

    func position(for time: String, in width: CGFloat) -> CGFloat {
        let hours = Double(time.components(separatedBy: " ")[0]) ?? 0
        let minutes = Double(time.components(separatedBy: " ")[1].replacingOccurrences(of: ":", with: ".")) ?? 0
        let totalMinutes = (hours * 60) + minutes
        return (totalMinutes / 1440) * width // 1440 minutes in a day
    }
}


#Preview {
    InsightView()
}

