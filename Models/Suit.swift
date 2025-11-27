import Foundation

enum Suit: String, CaseIterable, Codable {
    case hearts = "♥️"
    case diamonds = "♦️"
    case clubs = "♣️"
    case spades = "♠️"

    var symbol: String { rawValue }
}

// MARK: - Premium Deck Helper
extension Suit {
    var isRed: Bool {
        return self == .hearts || self == .diamonds
    }
}
