import Foundation
import SwiftData

@Model
final class Budget {
    var id: UUID = UUID()
    var category: String = "Other"
    var amount: Decimal = 0
    var month: Date = Date()

    init(category: String = "Other", amount: Decimal = 0, month: Date = Date()) {
        self.id = UUID()
        self.category = category
        self.amount = amount
        self.month = month
    }
}
