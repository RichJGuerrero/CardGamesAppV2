import Foundation
import SwiftUI

class BlackjackViewModel: ObservableObject {

    @Published var playerHand: [Card] = []
    @Published var dealerHand: [Card] = []
    @Published var deck: [Card] = []

    @Published var result: GameResult = .none
    @Published var isPlayerTurn: Bool = true

    // Animation flags
    @Published var showWinAnimation = false
    @Published var showLoseAnimation = false

    init() {
        newRound()
    }

    // MARK: - Start New Round
    func newRound() {
        deck = Deck.standard52().shuffled()

        playerHand = []
        dealerHand = []
        result = .none
        isPlayerTurn = true

        showWinAnimation = false
        showLoseAnimation = false

        // Deal 2 cards each
        playerHand.append(drawCard())
        playerHand.append(drawCard())
        dealerHand.append(drawCard())
        dealerHand.append(drawCard())

        // Check for dealer/player natural blackjack on the initial deal
        checkForInitialBlackjack()
    }

    // MARK: - Player Actions

    func hit() {
        guard isPlayerTurn, result == .none else { return }

        playerHand.append(drawCard())
        let value = handValue(playerHand)

        // Player hits exactly 21 → stop hitting and let dealer play
        if value == 21 {
            isPlayerTurn = false
            dealerTurn()
            return
        }

        // Player busts
        if value > 21 {
            determineOutcome()
        }
    }

    func stand() {
        guard isPlayerTurn else { return }

        isPlayerTurn = false
        dealerTurn()
    }

    // MARK: - Dealer Logic

    private func dealerTurn() {
        // Dealer must hit until 17+
        while handValue(dealerHand) < 17 {
            dealerHand.append(drawCard())
        }

        determineOutcome()
    }

    // MARK: - Draw Card

    private func drawCard() -> Card {
        return deck.removeLast()
    }

    // MARK: - Hand Value Calculation

    func handValue(_ hand: [Card]) -> Int {
        // Sum using blackjackValue from Rank.swift
        var total = hand.reduce(0) { partial, card in
            partial + card.rank.blackjackValue
        }

        // Count Aces
        let aces = hand.filter { $0.rank == .ace }.count

        var adjustedTotal = total
        var acesToAdjust = aces

        // Reduce Ace from 11 to 1 until no longer busting
        while adjustedTotal > 21 && acesToAdjust > 0 {
            adjustedTotal -= 10       // 11 → 1
            acesToAdjust -= 1
        }

        return adjustedTotal
    }

    // MARK: - Initial Blackjack Check (2-card naturals)

    private func hasNaturalBlackjack(_ hand: [Card]) -> Bool {
        hand.count == 2 && handValue(hand) == 21
    }

    private func checkForInitialBlackjack() {
        let playerBJ = hasNaturalBlackjack(playerHand)
        let dealerBJ = hasNaturalBlackjack(dealerHand)

        guard playerBJ || dealerBJ else {
            // No naturals, player proceeds as normal
            return
        }

        // No more player actions once a natural is found
        isPlayerTurn = false

        if playerBJ && dealerBJ {
            result = .push
        } else if playerBJ {
            result = .playerWins
            showWinAnimation = true
        } else if dealerBJ {
            result = .dealerWins
            showLoseAnimation = true
        }
    }

    // MARK: - Determine Outcome (non-natural)

    func determineOutcome() {
        let player = handValue(playerHand)
        let dealer = handValue(dealerHand)

        if player > 21 {
            result = .dealerWins
            showLoseAnimation = true
            return
        }

        if dealer > 21 {
            result = .playerWins
            showWinAnimation = true
            return
        }

        if player > dealer {
            result = .playerWins
            showWinAnimation = true
        } else if dealer > player {
            result = .dealerWins
            showLoseAnimation = true
        } else {
            result = .push
        }
    }
}

enum GameResult {
    case none
    case playerWins
    case dealerWins
    case push
}
