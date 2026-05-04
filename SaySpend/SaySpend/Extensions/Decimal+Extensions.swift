import Foundation

extension Decimal {
    var currencyString: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: self as NSDecimalNumber) ?? "$0.00"
    }
    
    var compactString: String {
        if self >= 1_000_000 {
            let value = NSDecimalNumber(decimal: self / 1_000_000).doubleValue
            return String(format: "$%.1fM", value)
        } else if self >= 1_000 {
            let value = NSDecimalNumber(decimal: self / 1_000).doubleValue
            return String(format: "$%.1fK", value)
        }
        return currencyString
    }
}
