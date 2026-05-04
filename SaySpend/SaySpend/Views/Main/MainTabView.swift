import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)
            
            ExpenseListView()
                .tabItem {
                    Label("Expenses", systemImage: "list.bullet.rectangle.portrait.fill")
                }
                .tag(1)
            
            StatisticsView()
                .tabItem {
                    Label("Stats", systemImage: "chart.pie.fill")
                }
                .tag(2)
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
                .tag(3)
        }
        .tint(.appPrimary)
    }
}
