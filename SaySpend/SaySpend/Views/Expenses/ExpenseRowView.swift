import SwiftUI

struct ExpenseRowView: View {
    let expense: Expense
    
    private var categoryItem: CategoryItem {
        CategoryItem.defaults.first { $0.name == expense.category } ?? CategoryItem.defaults.last!
    }
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.fromHex(categoryItem.color).opacity(0.15))
                    .frame(width: 44, height: 44)
                Image(systemName: categoryItem.icon)
                    .foregroundColor(Color.fromHex(categoryItem.color))
                    .font(.body)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(expense.merchant.isEmpty ? expense.category : expense.merchant)
                    .font(.body.bold())
                    .foregroundColor(.appTextPrimary)
                if !expense.note.isEmpty && expense.note != expense.merchant {
                    Text(expense.note)
                        .font(.caption)
                        .foregroundColor(.appTextSecondary)
                        .lineLimit(1)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                Text(expense.isIncome ? "+\(expense.amount.currencyString)" : expense.amount.currencyString)
                    .font(.body.bold())
                    .foregroundColor(expense.isIncome ? .appGreen : .appRed)
                Text(expense.date, style: .time)
                    .font(.caption2)
                    .foregroundColor(.appTextSecondary)
            }
        }
        .padding(.vertical, 4)
    }
}
