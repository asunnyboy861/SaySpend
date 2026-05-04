import SwiftUI
import SwiftData

struct AddExpenseView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var amount = ""
    @State private var category = "Food"
    @State private var merchant = ""
    @State private var note = ""
    @State private var isIncome = false
    @State private var date = Date()
    
    private let categories = CategoryItem.defaults
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Text("$")
                            .font(.title2.bold())
                        TextField("0.00", text: $amount)
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .keyboardType(.decimalPad)
                    }
                    
                    Toggle("Income", isOn: $isIncome)
                        .tint(.appGreen)
                }
                
                Section("Category") {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 12) {
                        ForEach(categories) { cat in
                            VStack(spacing: 4) {
                                ZStack {
                                    Circle()
                                        .fill(category == cat.name ? Color.fromHex(cat.color) : Color.fromHex(cat.color).opacity(0.15))
                                        .frame(width: 44, height: 44)
                                    Image(systemName: cat.icon)
                                        .foregroundColor(category == cat.name ? .white : Color.fromHex(cat.color))
                                }
                                Text(cat.name)
                                    .font(.caption2)
                                    .foregroundColor(category == cat.name ? .appTextPrimary : .appTextSecondary)
                            }
                            .onTapGesture {
                                withAnimation(.spring(duration: 0.3)) {
                                    category = cat.name
                                }
                            }
                        }
                    }
                    .padding(.vertical, 4)
                }
                
                Section("Details") {
                    TextField("Merchant", text: $merchant)
                    TextField("Note", text: $note)
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                }
            }
            .navigationTitle("Add Expense")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        saveExpense()
                    }
                    .bold()
                    .disabled(Decimal(string: amount) == nil)
                }
            }
        }
    }
    
    private func saveExpense() {
        guard let decimalAmount = Decimal(string: amount), decimalAmount > 0 else { return }
        let expense = Expense(
            amount: decimalAmount,
            category: category,
            merchant: merchant,
            note: note,
            date: date,
            isIncome: isIncome,
            inputMethod: "manual"
        )
        modelContext.insert(expense)
        dismiss()
    }
}
