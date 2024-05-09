import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
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
