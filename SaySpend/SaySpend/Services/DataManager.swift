import Foundation
import SwiftData

@Observable
final class DataManager {
    var useCloudKit: Bool = false {
        didSet {
            UserDefaults.standard.set(useCloudKit, forKey: "useCloudKit")
        }
    }
    
    init() {
        self.useCloudKit = UserDefaults.standard.bool(forKey: "useCloudKit")
    }
    
    static let shared = DataManager()
    
    func todayExpenses(modelContext: ModelContext) -> [Expense] {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        let predicate = #Predicate<Expense> { expense in
            expense.date >= startOfDay
        }
        let descriptor = FetchDescriptor(predicate: predicate, sortBy: [SortDescriptor(\.date, order: .reverse)])
        return (try? modelContext.fetch(descriptor)) ?? []
    }
    
    func expensesForMonth(date: Date, modelContext: ModelContext) -> [Expense] {
        let calendar = Calendar.current
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: date))!
        let endOfMonth = calendar.date(byAdding: .month, value: 1, to: startOfMonth)!
        let predicate = #Predicate<Expense> { expense in
            expense.date >= startOfMonth && expense.date < endOfMonth
        }
        let descriptor = FetchDescriptor(predicate: predicate, sortBy: [SortDescriptor(\.date, order: .reverse)])
        return (try? modelContext.fetch(descriptor)) ?? []
    }
    
    func totalAmount(for expenses: [Expense]) -> Decimal {
        expenses.filter { !$0.isIncome }.reduce(0) { $0 + $1.amount }
    }
    
    func totalIncome(for expenses: [Expense]) -> Decimal {
        expenses.filter { $0.isIncome }.reduce(0) { $0 + $1.amount }
    }
    
    func categoryTotals(for expenses: [Expense]) -> [String: Decimal] {
        var totals: [String: Decimal] = [:]
        for expense in expenses where !expense.isIncome {
            totals[expense.category, default: 0] += expense.amount
        }
        return totals
    }
    
    func groupedByDate(_ expenses: [Expense]) -> [(String, [Expense])] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: expenses) { expense in
            calendar.startOfDay(for: expense.date)
        }
        return grouped
            .sorted { $0.key > $1.key }
            .map { (date, expenses) in
                let formatter = DateFormatter()
                if Calendar.current.isDateInToday(date) {
                    formatter.dateStyle = .medium
                    return ("Today", expenses)
                } else if Calendar.current.isDateInYesterday(date) {
                    return ("Yesterday", expenses)
                } else {
                    formatter.dateStyle = .medium
                    return (formatter.string(from: date), expenses)
                }
            }
    }
}
