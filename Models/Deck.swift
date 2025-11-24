// Deck.swift

import Foundation

struct Deck {
    private(set) var cards: [Card] = []
    
    init() {
        reset()
    }
    
    mutating func reset() {
        cards.removeAll()
        
        for suit in Suit.allCases {
            for rank in Rank.allCases {
                cards.append(Card(rank: rank, suit: suit))
            }
        }
    }
    
    mutating func shuffle() {
        cards.shuffle()
    }
    
    mutating func draw() -> Card? {
        guard !cards.isEmpty else { return nil }
        return cards.removeLast()
    }
}
