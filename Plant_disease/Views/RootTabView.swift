import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            NavigationStack {
                HomeView()
            }
            .tabItem { Label("Home", systemImage: "house.fill") }

            NavigationStack {
                ScanHistoryView()
            }
            .tabItem { Label("Scan History", systemImage: "clock.arrow.circlepath") }

            NavigationStack {
                YourPlantsView()
            }
            .tabItem { Label("Your Plants", systemImage: "leaf.fill") }

            NavigationStack {
                SuggestionsView()
            }
            .tabItem { Label("Suggestions", systemImage: "lightbulb.fill") }
        }
        .tint(.accentGreen)
    }
}

#Preview {
    RootTabView()
}
