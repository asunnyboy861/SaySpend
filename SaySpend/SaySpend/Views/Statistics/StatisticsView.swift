import SwiftUI
import SwiftData
import Charts

struct StatisticsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var expenses: [Expense]
    @State private var selectedMonth = Date()
    
    private let dataManager = DataManager.shared
    
    private var monthExpenses: [Expense] {
        dataManager.expensesForMonth(date: selectedMonth, modelContext: modelContext)
    }
    
    private var totalSpent: Decimal {
        dataManager.totalAmount(for: monthExpenses)
    }
    
    private var totalIncome: Decimal {
        dataManager.totalIncome(for: monthExpenses)
    }
    
    private var categoryTotals: [String: Decimal] {
        dataManager.categoryTotals(for: monthExpenses)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    monthNavigation
                    
                    summaryCards
                    
                    categoryBreakdownChart
                    
                    dailySpendingChart
                }
                .padding()
            }
            .background(Color.appBackground)
            .navigationTitle("Statistics")
        }
    }
    
    private var monthNavigation: some View {
        HStack {
            Button(action: { changeMonth(-1) }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.appPrimary)
            }
            Spacer()
            Text(selectedMonth.monthString)
                .font(.headline)
            Spacer()
            Button(action: { changeMonth(1) }) {
                Image(systemName: "chevron.right")
                    .foregroundColor(.appPrimary)
            }
        }
        .padding(.horizontal)
    }
    
    private var summaryCards: some View {
        HStack(spacing: 12) {
            SummaryCard(title: "Spent", amount: totalSpent, color: .appRed)
            SummaryCard(title: "Income", amount: totalIncome, color: .appGreen)
            SummaryCard(title: "Net", amount: totalIncome - totalSpent, color: totalIncome >= totalSpent ? .appGreen : .appRed)
        }
    }
    
    private var categoryBreakdownChart: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("By Category")
                .font(.headline)
                .foregroundColor(.appTextPrimary)
            
            if categoryTotals.isEmpty {
                Text("No expenses this month")
                    .font(.subheadline)
                    .foregroundColor(.appTextSecondary)
            } else {
                let total = categoryTotals.values.reduce(Decimal(0), +)
                let chartData = categoryTotals.sorted { $0.value > $1.value }.map { (cat, amt) in
                    CategoryChartData(name: cat, amount: NSDecimalNumber(decimal: amt).doubleValue, color: CategoryItem.defaults.first { $0.name == cat }?.color ?? "95A5A6")
                }
                
                Chart(chartData) { item in
                    SectorMark(
                        angle: .value("Amount", item.amount),
                        innerRadius: .ratio(0.5),
                        angularInset: 2
                    )
                    .foregroundStyle(Color.fromHex(item.color))
                    .annotation(position: .overlay) {
                        if item.amount / NSDecimalNumber(decimal: total).doubleValue > 0.1 {
                            VStack(spacing: 2) {
                                Text(item.name)
                                    .font(.caption2.bold())
                                Text(Decimal(item.amount).currencyString)
                                    .font(.caption2)
                            }
                            .foregroundStyle(.white)
                        }
                    }
                }
                .frame(height: 200)
                
                ForEach(chartData) { item in
                    HStack {
                        Image(systemName: CategoryItem.defaults.first { $0.name == item.name }?.icon ?? "ellipsis.circle.fill")
                            .foregroundColor(Color.fromHex(item.color))
                        Text(item.name)
                            .font(.subheadline)
                        Spacer()
                        Text(Decimal(item.amount).currencyString)
                            .font(.subheadline.bold())
                        let pct = total > 0 ? Int(item.amount / NSDecimalNumber(decimal: total).doubleValue * 100) : 0
                        Text("\(pct)%")
                            .font(.caption)
                            .foregroundColor(.appTextSecondary)
                    }
                }
            }
        }
        .padding()
        .background(Color.appCard)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 8, y: 4)
    }
    
    private var dailySpendingChart: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Daily Spending")
                .font(.headline)
                .foregroundColor(.appTextPrimary)
            
            let calendar = Calendar.current
            let dailyData = Dictionary(grouping: monthExpenses.filter { !$0.isIncome }) { expense in
                calendar.component(.day, from: expense.date)
            }.map { (day, exps) in
                DailyData(day: day, amount: NSDecimalNumber(decimal: exps.reduce(Decimal(0)) { $0 + $1.amount }).doubleValue)
            }.sorted { $0.day < $1.day }
            
            Chart(dailyData) { item in
                BarMark(
                    x: .value("Day", item.day),
                    y: .value("Amount", item.amount)
                )
                .foregroundStyle(Color.blue.gradient)
                .cornerRadius(4)
            }
            .frame(height: 180)
            .chartYAxisLabel("$")
        }
        .padding()
        .background(Color.appCard)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 8, y: 4)
    }
    
    private func changeMonth(_ offset: Int) {
        if let newDate = Calendar.current.date(byAdding: .month, value: offset, to: selectedMonth) {
            withAnimation { selectedMonth = newDate }
        }
    }
}

struct CategoryChartData: Identifiable {
    let id = UUID()
    let name: String
    let amount: Double
    let color: String
}

struct DailyData: Identifiable {
    let id = UUID()
    let day: Int
    let amount: Double
}

struct SummaryCard: View {
    let title: String
    let amount: Decimal
    let color: Color
    
    var body: some View {
        VStack(spacing: 6) {
            Text(title)
                .font(.caption)
                .foregroundColor(.appTextSecondary)
            Text(amount.currencyString)
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(color.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
