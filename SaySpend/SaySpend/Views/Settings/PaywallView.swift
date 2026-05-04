import SwiftUI
import StoreKit

struct PaywallView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var purchaseManager = PurchaseManager.shared
    @State private var selectedPlan: String = "yearly"
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    Image(systemName: "crown.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(.yellow)
                        .padding(.top, 20)
                    
                    Text("SaySpend Premium")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                    
                    Text("Unlock the full power of expense tracking")
                        .font(.subheadline)
                        .foregroundColor(.appTextSecondary)
                        .multilineTextAlignment(.center)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        FeatureRow(icon: "target", text: "Budget management with alerts")
                        FeatureRow(icon: "icloud.fill", text: "iCloud sync across devices")
                        FeatureRow(icon: "square.grid.2x2.fill", text: "Home screen widgets")
                        FeatureRow(icon: "chart.bar.fill", text: "Full monthly & yearly stats")
                        FeatureRow(icon: "waveform", text: "Siri shortcuts integration")
                        FeatureRow(icon: "star.fill", text: "Priority support")
                    }
                    .padding()
                    .background(Color.appCard)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    
                    VStack(spacing: 12) {
                        planButton(id: "monthly", title: "Monthly", price: "$2.99/mo", subtitle: nil)
                        planButton(id: "yearly", title: "Yearly", price: "$19.99/yr", subtitle: "Save 44%")
                        planButton(id: "lifetime", title: "Lifetime", price: "$39.99", subtitle: "Pay once, own forever")
                    }
                    
                    Button(action: purchase) {
                        Text("Subscribe Now")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.appPrimary)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    
                    Button("Restore Purchases") {
                        Task { await purchaseManager.restorePurchases() }
                    }
                    .font(.caption)
                    .foregroundColor(.appTextSecondary)
                    
                    Text("Free trial for 7 days. Cancel anytime.")
                        .font(.caption2)
                        .foregroundColor(.appTextSecondary)
                }
                .padding()
            }
            .navigationTitle("")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close") { dismiss() }
                }
            }
            .task {
                await purchaseManager.loadProducts()
            }
        }
    }
    
    private func planButton(id: String, title: String, price: String, subtitle: String?) -> some View {
        Button(action: { selectedPlan = id }) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        Text(title)
                            .font(.body.bold())
                        if let subtitle {
                            Text(subtitle)
                                .font(.caption)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.appGreen.opacity(0.15))
                                .foregroundColor(.appGreen)
                                .clipShape(Capsule())
                        }
                    }
                    Text(price)
                        .font(.subheadline)
                        .foregroundColor(.appTextSecondary)
                }
                Spacer()
                Image(systemName: selectedPlan == id ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(selectedPlan == id ? .appPrimary : .appTextSecondary)
            }
            .padding()
            .background(selectedPlan == id ? Color.appPrimary.opacity(0.05) : Color.appCard)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(selectedPlan == id ? Color.appPrimary : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
    }
    
    private func purchase() {
        Task {
            let productID: String
            switch selectedPlan {
            case "monthly": productID = "com.zzoutuo.SaySpend.monthly"
            case "yearly": productID = "com.zzoutuo.SaySpend.yearly"
            case "lifetime": productID = "com.zzoutuo.SaySpend.lifetime"
            default: productID = "com.zzoutuo.SaySpend.yearly"
            }
            
            if let product = purchaseManager.products.first(where: { $0.id == productID }) {
                let success = await purchaseManager.purchase(product)
                if success {
                    dismiss()
                }
            }
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.appPrimary)
                .frame(width: 24)
            Text(text)
                .font(.subheadline)
        }
    }
}
