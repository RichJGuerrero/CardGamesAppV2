//
//  Deck.swift
//  CardGamesAppV2
//

import Foundation

struct Deck {

    // Stored card list
    private(set) var cards: [Card] = []

    // MARK: - Init
    init() {
        reset()
    }

    // MARK: - Static Factory (Needed for BlackjackViewModel)
    static func standard52() -> [Card] {
        var cards: [Card] = []

        for suit in Suit.allCases {
            for rank in Rank.allCases {
                cards.append(Card(rank: rank, suit: suit))
            }
        }

        return cards
    }

    // MARK: - Reset Deck
    mutating func reset() {
        cards.removeAll()

        for suit in Suit.allCases {
            for rank in Rank.allCases {
                cards.append(Card(rank: rank, suit: suit))
            }
        }
    }

    // MARK: - Shuffle
    mutating func shuffle() {
        cards.shuffle()
    }

    // MARK: - Draw
    mutating func draw() -> Card? {
        guard !cards.isEmpty else { return nil }
        return cards.removeLast()
    }
}
