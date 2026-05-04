import Foundation

struct CategoryItem: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let icon: String
    let color: String

    static let defaults: [CategoryItem] = [
        CategoryItem(name: "Coffee", icon: "cup.and.saucer.fill", color: "8B4513"),
        CategoryItem(name: "Food", icon: "fork.knife", color: "FF6B35"),
        CategoryItem(name: "Transport", icon: "car.fill", color: "4A90D9"),
        CategoryItem(name: "Shopping", icon: "bag.fill", color: "E91E8C"),
        CategoryItem(name: "Entertainment", icon: "gamecontroller.fill", color: "9B59B6"),
        CategoryItem(name: "Health", icon: "heart.fill", color: "2ECC71"),
        CategoryItem(name: "Bills", icon: "doc.text.fill", color: "F39C12"),
        CategoryItem(name: "Education", icon: "book.fill", color: "3498DB"),
        CategoryItem(name: "Travel", icon: "airplane", color: "1ABC9C"),
        CategoryItem(name: "Other", icon: "ellipsis.circle.fill", color: "95A5A6"),
    ]
}
