import SwiftUI
import SwiftData

@main
struct SaySpendApp: App {
    @State private var modelContainer: ModelContainer
    
    init() {
        let useCloudKit = UserDefaults.standard.bool(forKey: "useCloudKit")
        
        if useCloudKit {
            let schema = Schema([Expense.self, Budget.self])
            let modelConfiguration = ModelConfiguration(
                "iCloud",
                schema: schema,
                cloudKitDatabase: .automatic
            )
            do {
                modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
            } catch {
                fatalError("Failed to create iCloud ModelContainer: \(error)")
            }
        } else {
            let schema = Schema([Expense.self, Budget.self])
            let modelConfiguration = ModelConfiguration(
                "Local",
                schema: schema,
                cloudKitDatabase: .none
            )
            do {
                modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
            } catch {
                fatalError("Failed to create Local ModelContainer: \(error)")
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
        .modelContainer(modelContainer)
    }
}
