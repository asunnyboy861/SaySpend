import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var showVoiceInput = false
    @State private var showAddExpense = false
    @State private var showReceiptScanner = false
    @State private var todayExpenses: [Expense] = []
    
    private let dataManager = DataManager.shared
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    todaySummaryCard
                    
                    voiceInputSection
                    
                    recentExpensesSection
                }
                .padding()
            }
            .background(Color.appBackground)
            .navigationTitle("SaySpend")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button(action: { showAddExpense = true }) {
                            Label("Manual Entry", systemImage: "square.and.pencil")
                        }
                        Button(action: { showReceiptScanner = true }) {
                            Label("Scan Receipt", systemImage: "camera")
                        }
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showVoiceInput) {
                VoiceInputView()
            }
            .sheet(isPresented: $showAddExpense) {
                AddExpenseView()
            }
            .sheet(isPresented: $showReceiptScanner) {
                ReceiptScannerView()
            }
            .onAppear {
                loadTodayExpenses()
            }
        }
    }
    
    private var todaySummaryCard: some View {
        VStack(spacing: 12) {
            Text("Today's Spending")
                .font(.subheadline)
                .foregroundColor(.appTextSecondary)
            
            Text(dataManager.totalAmount(for: todayExpenses).currencyString)
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .foregroundColor(.appTextPrimary)
            
            HStack(spacing: 24) {
                VStack(spacing: 4) {
                    Text(todayExpenses.filter { !$0.isIncome }.count.description)
                        .font(.title3.bold())
                    Text("Expenses")
                        .font(.caption)
                        .foregroundColor(.appTextSecondary)
                }
                VStack(spacing: 4) {
                    Text(dataManager.totalIncome(for: todayExpenses).currencyString)
                        .font(.title3.bold())
                        .foregroundColor(.appGreen)
                    Text("Income")
                        .font(.caption)
                        .foregroundColor(.appTextSecondary)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(24)
        .background(Color.appCard)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 8, y: 4)
    }
    
    private var voiceInputSection: some View {
        Button(action: { showVoiceInput = true }) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Color.appPrimary.opacity(0.1))
                        .frame(width: 56, height: 56)
                    Image(systemName: "mic.fill")
                        .font(.title2)
                        .foregroundColor(.appPrimary)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Just say it")
                        .font(.headline)
                        .foregroundColor(.appTextPrimary)
                    Text("Tap to log an expense by voice")
                        .font(.subheadline)
                        .foregroundColor(.appTextSecondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.appTextSecondary)
            }
            .padding()
            .background(Color.appCard)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.05), radius: 8, y: 4)
        }
        .buttonStyle(.plain)
    }
    
    private var recentExpensesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent")
                .font(.headline)
                .foregroundColor(.appTextPrimary)
            
            if todayExpenses.isEmpty {
                EmptyStateView(
                    icon: "tray",
                    title: "No expenses yet",
                    subtitle: "Tap the microphone to log your first expense"
                )
            } else {
                ForEach(todayExpenses.prefix(5)) { expense in
                    ExpenseRowView(expense: expense)
                }
            }
        }
    }
    
    private func loadTodayExpenses() {
        todayExpenses = dataManager.todayExpenses(modelContext: modelContext)
    }
}
