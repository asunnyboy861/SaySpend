import SwiftUI

struct ExpenseConfirmationCard: View {
    @Binding var amount: String
    @Binding var category: String
    @Binding var merchant: String
    
    private let categories = CategoryItem.defaults
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Confirm Expense")
                .font(.headline)
                .foregroundColor(.appTextPrimary)
            
            HStack {
                Text("$")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.appTextPrimary)
                TextField("0.00", text: $amount)
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .keyboardType(.decimalPad)
                    .foregroundColor(.appTextPrimary)
            }
            .padding()
            .background(Color.appBackground)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            TextField("Merchant", text: $merchant)
                .textFieldStyle(.roundedBorder)
                .font(.body)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(categories) { cat in
                        CategoryPill(
                            name: cat.name,
                            icon: cat.icon,
                            isSelected: category == cat.name,
                            color: Color.fromHex(cat.color)
                        ) {
                            category = cat.name
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color.appCard)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 8, y: 4)
    }
}

struct CategoryPill: View {
    let name: String
    let icon: String
    let isSelected: Bool
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.caption)
                Text(name)
                    .font(.caption.bold())
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(isSelected ? color : color.opacity(0.15))
            .foregroundStyle(isSelected ? .white : color)
            .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}
