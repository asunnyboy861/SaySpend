import SwiftUI
import SwiftData

struct BudgetView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var budgets: [Budget]
    @Query private var expenses: [Expense]
    @State private var showAddBudget = false
    @State private var newBudgetCategory = "Food"
    @State private var newBudgetAmount = ""
    
    private let dataManager = DataManager.shared
    private let categories = CategoryItem.defaults
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(categories) { cat in
                    if let budget = budgets.first(where: { $0.category == cat.name }) {
                        budgetRow(category: cat, budget: budget)
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Budgets")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showAddBudget = true }) {
                        Image(systemName: "plus.circle.fill")
                    }
                }
            }
            .overlay {
                if budgets.isEmpty {
                    EmptyStateView(
                        icon: "target",
                        title: "No budgets set",
                        subtitle: "Set monthly budgets to track your spending goals"
                    )
                }
            }
            .alert("Add Budget", isPresented: $showAddBudget) {
                TextField("Amount", text: $newBudgetAmount)
                    .keyboardType(.decimalPad)
                Button("Cancel", role: .cancel) {}
                Button("Save") {
                    saveBudget()
                }
                .disabled(Decimal(string: newBudgetAmount) == nil)
            } message: {
                Text("Set monthly budget for \(newBudgetCategory)")
            }
        }
    }
    
    private func budgetRow(category: CategoryItem, budget: Budget) -> some View {
        let spent = dataManager.categoryTotals(for: expenses.filter {
            Calendar.current.isDate($0.date, equalTo: budget.month, toGranularity: .month)
        })[category.name] ?? 0
        let progressDouble = budget.amount > 0 ? NSDecimalNumber(decimal: spent / budget.amount).doubleValue : 0.0
        let isOver = progressDouble > 1.0
        
        return VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: category.icon)
                    .foregroundColor(Color.fromHex(category.color))
                Text(category.name)
                    .font(.body.bold())
                Spacer()
                Text("\(spent.currencyString) / \(budget.amount.currencyString)")
                    .font(.caption)
                    .foregroundColor(isOver ? .appRed : .appTextSecondary)
            }
            
            ProgressView(value: min(progressDouble, 1.0))
                .tint(isOver ? .appRed : Color.fromHex(category.color))
            
            if isOver {
                Text("Over budget by \((spent - budget.amount).currencyString)")
                    .font(.caption)
                    .foregroundColor(.appRed)
            }
        }
        .padding(.vertical, 4)
    }
    
    private func saveBudget() {
        guard let amount = Decimal(string: newBudgetAmount), amount > 0 else { return }
        if let existing = budgets.first(where: { $0.category == newBudgetCategory }) {
            existing.amount = amount
        } else {
            let budget = Budget(category: newBudgetCategory, amount: amount)
            modelContext.insert(budget)
        }
        newBudgetAmount = ""
    }
}
