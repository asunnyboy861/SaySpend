import Foundation
import SwiftData

@Model
final class Expense {
    var id: UUID = UUID()
    var amount: Decimal = 0
    var category: String = "Other"
    var merchant: String = ""
    var note: String = ""
    var date: Date = Date()
    var isIncome: Bool = false
    var inputMethod: String = "manual"

    init(amount: Decimal = 0, category: String = "Other", merchant: String = "", note: String = "", date: Date = Date(), isIncome: Bool = false, inputMethod: String = "manual") {
        self.id = UUID()
        self.amount = amount
        self.category = category
        self.merchant = merchant
        self.note = note
        self.date = date
        self.isIncome = isIncome
        self.inputMethod = inputMethod
    }
}
