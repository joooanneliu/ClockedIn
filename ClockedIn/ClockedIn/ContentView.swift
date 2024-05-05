import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
//            TodoView()
//                .tabItem {
//                    Image(systemName: "list.clipboard")
//                    Text("To-do")
//                }
            StopwatchListView()
                .tabItem {
                    Image(systemName: "clock")
                    Text("Stopwatch")
                }
            SummaryView()
                .tabItem {
                    Image(systemName: "lightbulb")
                    Text("Summary")
                }
        }
    }
}

#Preview {
    ContentView()
}
