// Card.swift

import Foundation

struct Card: Identifiable {
    let id = UUID()
    let rank: Rank
    let suit: Suit
    
    /// Convenience string, e.g. "A♠️" or "10♦️"
    var displayString: String {
        "\(rank.rawValue)\(suit.rawValue)"
    }
}
