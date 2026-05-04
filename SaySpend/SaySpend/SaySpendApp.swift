import SwiftUI
import SwiftData

@main
struct SaySpendApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
        .modelContainer(for: [Expense.self, Budget.self])
    }
}
