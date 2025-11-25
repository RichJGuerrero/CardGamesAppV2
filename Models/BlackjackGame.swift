import Foundation

enum BlackjackResult {
    case none
    case playerBlackjack
    case dealerBlackjack
    case playerBust
    case dealerBust
    case playerWins
    case dealerWins
    case push
}

struct BlackjackGame {

    private(set) var deck: [Card] = []
    private(set) var playerHand: [Card] = []
    private(set) var dealerHand: [Card] = []
    private(set) var result: BlackjackResult = .none
    private(set) var isPlayerTurn: Bool = true

    init() {
        startNewRound()
    }

    // MARK: - API

    mutating func startNewRound() {
        deck = Self.makeShuffledDeck()
        playerHand = []
        dealerHand = []
        result = .none
        isPlayerTurn = true

        // Initial deal
        playerHand.append(drawCard())
        dealerHand.append(drawCard())
        playerHand.append(drawCard())
        dealerHand.append(drawCard())

        evaluateInitialBlackjack()
    }

    mutating func playerHit() {
        guard canHit else { return }
        playerHand.append(drawCard())

        if handValue(playerHand) > 21 {
            result = .playerBust
            isPlayerTurn = false
        }
    }

    mutating func playerStand() {
        guard canStand else { return }
        isPlayerTurn = false
        dealerTurn()
    }

    // MARK: - Dealer Logic

    private mutating func dealerTurn() {
        while handValue(dealerHand) < 17 {
            dealerHand.append(drawCard())
        }

        let player = handValue(playerHand)
        let dealer = handValue(dealerHand)

        if dealer > 21 {
            result = .dealerBust
        } else if dealer > player {
            result = .dealerWins
        } else if dealer < player {
            result = .playerWins
        } else {
            result = .push
        }
    }

    // MARK: - State Computed Vars

    var playerValue: Int { handValue(playerHand) }
    var dealerValue: Int { handValue(dealerHand) }

    var canHit: Bool {
        isPlayerTurn && result == .none && playerValue <= 21
    }

    var canStand: Bool {
        isPlayerTurn && result == .none
    }

    // MARK: - Helpers

    private mutating func drawCard() -> Card {
        return deck.removeLast()
    }

    private mutating func evaluateInitialBlackjack() {
        let p = handValue(playerHand)
        let d = handValue(dealerHand)

        let playerBJ = (playerHand.count == 2 && p == 21)
        let dealerBJ = (dealerHand.count == 2 && d == 21)

        if playerBJ || dealerBJ {
            if playerBJ && dealerBJ {
                result = .push
            } else if playerBJ {
                result = .playerBlackjack
            } else {
                result = .dealerBlackjack
            }
            isPlayerTurn = false
        }
    }

    // MARK: - Static Utilities

    private func handValue(_ cards: [Card]) -> Int {
        var total = 0
        var aces = 0

        for card in cards {
            switch card.rank {
            case .ace:
                total += 11
                aces += 1
            case .jack, .queen, .king:
                total += 10
            default:
                total += card.rank.rawValue
            }
        }

        // Ace adjustment
        while total > 21 && aces > 0 {
            total -= 10
            aces -= 1
        }

        return total
    }

    private static func makeShuffledDeck() -> [Card] {
        var cards: [Card] = []
        for suit in Suit.allCases {
            for rank in Rank.allCases {
                cards.append(Card(rank: rank, suit: suit))
            }
        }
        return cards.shuffled()
    }
}
