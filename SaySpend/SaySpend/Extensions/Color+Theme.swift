import SwiftUI

extension Color {
    static let appPrimary = Color(red: 0/255, green: 122/255, blue: 255/255)
    static let appGreen = Color(red: 52/255, green: 199/255, blue: 89/255)
    static let appRed = Color(red: 255/255, green: 59/255, blue: 48/255)
    static let appBackground = Color(red: 242/255, green: 242/255, blue: 247/255)
    static let appCard = Color.white
    static let appTextPrimary = Color(red: 26/255, green: 26/255, blue: 26/255)
    static let appTextSecondary = Color(red: 142/255, green: 142/255, blue: 147/255)
    
    static func fromHex(_ hex: String) -> Color {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        return Color(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
}
