// Hand.swift

import Foundation

struct Hand {
    var cards: [Card] = []
    
    mutating func add(_ card: Card) {
        cards.append(card)
    }
    
    mutating func clear() {
        cards.removeAll()
    }
    
    /// Blackjack total with ace adjustment (11 → 1 if needed).
    var value: Int {
        var total = 0
        var aceCount = 0
        
        for card in cards {
            total += card.rank.blackjackValue
            if card.rank == .ace {
                aceCount += 1
            }
        }
        
        // Downgrade aces from 11 to 1 while busting
        while total > 21 && aceCount > 0 {
            total -= 10
            aceCount -= 1
        }
        
        return total
    }
    
    /// True if exactly two cards totaling 21.
    var isBlackjack: Bool {
        cards.count == 2 && value == 21
    }
}
