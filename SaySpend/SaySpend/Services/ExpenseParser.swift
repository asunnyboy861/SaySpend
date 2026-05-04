import Foundation
import NaturalLanguage

struct ParsedExpense {
    var amount: Decimal?
    var category: String?
    var merchant: String?
    var note: String?
}

final class ExpenseParser {
    private let categoryKeywords: [String: [String]] = [
        "Coffee": ["coffee", "latte", "espresso", "starbucks", "dunkin", "cappuccino", "mocha", "tea", "brew"],
        "Food": ["lunch", "dinner", "breakfast", "pizza", "sushi", "burger", "taco", "restaurant", "takeout", "groceries", "snack", "meal", "food"],
        "Transport": ["uber", "lyft", "taxi", "gas", "fuel", "parking", "bus", "metro", "subway", "train", "ride"],
        "Shopping": ["amazon", "target", "walmart", "clothes", "shoes", "store", "shop", "purchase"],
        "Entertainment": ["movie", "netflix", "spotify", "game", "concert", "ticket", "show"],
        "Health": ["pharmacy", "doctor", "medicine", "gym", "fitness", "hospital", "dental"],
        "Bills": ["rent", "electric", "water", "internet", "phone", "insurance", "utility", "subscription"],
        "Education": ["book", "course", "tuition", "school", "class", "lesson"],
        "Travel": ["hotel", "flight", "airbnb", "vacation", "trip"],
    ]
    
    private let amountPattern = #"(?:\$|dollars?|bucks?)?\s?(\d+\.?\d*)\s?(?:\$|dollars?|bucks?)?"#
    private let merchantPattern = #"(?:at|from|for|on)\s+([A-Z][a-zA-Z\s]+?)(?:\s+(?:for|on|in)\s|$)"#
    
    func parse(_ text: String) -> ParsedExpense {
        var expense = ParsedExpense()
        let lowercased = text.lowercased()
        
        expense.amount = extractAmount(from: text)
        expense.category = inferCategory(from: lowercased)
        expense.merchant = extractMerchant(from: text)
        expense.note = text
        
        return expense
    }
    
    private func extractAmount(from text: String) -> Decimal? {
        guard let regex = try? NSRegularExpression(pattern: amountPattern, options: .caseInsensitive) else { return nil }
        let range = NSRange(text.startIndex..., in: text)
        guard let match = regex.firstMatch(in: text, range: range),
              let amountRange = Range(match.range(at: 1), in: text) else { return nil }
        return Decimal(string: String(text[amountRange]))
    }
    
    private func inferCategory(from text: String) -> String? {
        for (category, keywords) in categoryKeywords {
            if keywords.contains(where: { text.contains($0) }) {
                return category
            }
        }
        return "Other"
    }
    
    private func extractMerchant(from text: String) -> String? {
        guard let regex = try? NSRegularExpression(pattern: merchantPattern, options: []) else { return nil }
        let range = NSRange(text.startIndex..., in: text)
        guard let match = regex.firstMatch(in: text, range: range),
              let merchantRange = Range(match.range(at: 1), in: text) else { return nil }
        return String(text[merchantRange]).trimmingCharacters(in: .whitespaces)
    }
}
