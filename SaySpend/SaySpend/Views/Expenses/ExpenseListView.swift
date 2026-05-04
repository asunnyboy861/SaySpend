import SwiftUI
import SwiftData

struct ExpenseListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Expense.date, order: .reverse) private var expenses: [Expense]
    @State private var searchText = ""
    @State private var selectedCategory: String?
    @State private var showAddExpense = false
    
    private let dataManager = DataManager.shared
    
    var filteredExpenses: [Expense] {
        var result = expenses
        if !searchText.isEmpty {
            result = result.filter {
                $0.merchant.localizedCaseInsensitiveContains(searchText) ||
                $0.note.localizedCaseInsensitiveContains(searchText) ||
                $0.category.localizedCaseInsensitiveContains(searchText)
            }
        }
        if let category = selectedCategory {
            result = result.filter { $0.category == category }
        }
        return result
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                categoryFilter
                
                if filteredExpenses.isEmpty {
                    Spacer()
                    EmptyStateView(
                        icon: "tray",
                        title: "No expenses found",
                        subtitle: "Add your first expense to get started"
                    )
                    Spacer()
                } else {
                    let grouped = dataManager.groupedByDate(filteredExpenses)
                    List {
                        ForEach(grouped, id: \.0) { date, items in
                            Section {
                                ForEach(items) { expense in
                                    ExpenseRowView(expense: expense)
                                }
                            } header: {
                                HStack {
                                    Text(date)
                                        .font(.subheadline.bold())
                                    Spacer()
                                    let total = dataManager.totalAmount(for: items)
                                    Text(total.currencyString)
                                        .font(.subheadline.bold())
                                        .foregroundColor(.appRed)
                                }
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("Expenses")
            .searchable(text: $searchText, prompt: "Search expenses...")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showAddExpense = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                    }
                }
            }
            .sheet(isPresented: $showAddExpense) {
                AddExpenseView()
            }
        }
    }
    
    private var categoryFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                CategoryPill(
                    name: "All",
                    icon: "square.grid.2x2.fill",
                    isSelected: selectedCategory == nil,
                    color: .appPrimary
                ) {
                    selectedCategory = nil
                }
                
                ForEach(CategoryItem.defaults) { cat in
                    CategoryPill(
                        name: cat.name,
                        icon: cat.icon,
                        isSelected: selectedCategory == cat.name,
                        color: Color.fromHex(cat.color)
                    ) {
                        selectedCategory = cat.name
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
        .background(Color.appCard)
    }
}
