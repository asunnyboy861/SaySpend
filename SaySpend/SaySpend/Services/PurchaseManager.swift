import StoreKit

@Observable
final class PurchaseManager {
    var products: [Product] = []
    var purchasedProductIDs: Set<String> = []
    var isPremium: Bool = false
    
    private var transactionListener: Task<Void, Never>?
    
    static let shared = PurchaseManager()
    
    let productIDs = [
        "com.zzoutuo.SaySpend.monthly",
        "com.zzoutuo.SaySpend.yearly",
        "com.zzoutuo.SaySpend.lifetime"
    ]
    
    init() {
        transactionListener = Task {
            for await result in Transaction.updates {
                if case .verified(let transaction) = result {
                    purchasedProductIDs.insert(transaction.productID)
                    isPremium = true
                    await transaction.finish()
                }
            }
        }
    }
    
    deinit {
        transactionListener?.cancel()
    }
    
    func loadProducts() async {
        do {
            products = try await Product.products(for: productIDs)
        } catch {
        }
    }
    
    func restorePurchases() async {
        do {
            try await AppStore.sync()
            await updatePurchasedProducts()
        } catch {
        }
    }
    
    func purchase(_ product: Product) async -> Bool {
        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                if case .verified(let transaction) = verification {
                    purchasedProductIDs.insert(transaction.productID)
                    isPremium = true
                    await transaction.finish()
                    return true
                }
            case .pending, .userCancelled:
                break
            @unknown default:
                break
            }
        } catch {
        }
        return false
    }
    
    func updatePurchasedProducts() async {
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result {
                if productIDs.contains(transaction.productID) {
                    purchasedProductIDs.insert(transaction.productID)
                    isPremium = true
                    await transaction.finish()
                }
            }
        }
    }
    
    var monthlyProduct: Product? {
        products.first { $0.id == "com.zzoutuo.SaySpend.monthly" }
    }
    
    var yearlyProduct: Product? {
        products.first { $0.id == "com.zzoutuo.SaySpend.yearly" }
    }
    
    var lifetimeProduct: Product? {
        products.first { $0.id == "com.zzoutuo.SaySpend.lifetime" }
    }
}
