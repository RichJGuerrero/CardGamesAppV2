//  BlackjackViewModel.swift
//  CardGamesAppV2

import Foundation

final class BlackjackViewModel: ObservableObject {

    // MARK: - Published State

    @Published var playerHand: [Card] = []
    @Published var dealerHand: [Card] = []

    @Published var result: GameResult = .none

    @Published var showWinAnimation: Bool = false
    @Published var showLoseAnimation: Bool = false

    @Published var isRoundActive: Bool = true

    // MARK: - Private State

    private var deck = Deck()

    // MARK: - Init

    init() {
        newRound()
    }

    // MARK: - Public API

    func newRound() {
        // Reset deck & hands
        deck.reset()
        deck.shuffle()

        playerHand.removeAll()
        dealerHand.removeAll()

        result = .none
        showWinAnimation = false
        showLoseAnimation = false
        isRoundActive = true

        dealInitialCards()
        evaluateNaturals()
    }

    func hit() {
        guard isRoundActive, result == .none else { return }
        guard let card = deck.draw() else { return }

        playerHand.append(card)

        let value = handValue(playerHand)

        if value > 21 {
            // Player busts
            isRoundActive = false
            result = .dealerWins
            showLoseAnimation = true
        } else if value == 21 {
            // Non-natural 21 -> auto stand
            isRoundActive = false
            dealerPlayAndResolve()
        }
    }

    func stand() {
        guard isRoundActive, result == .none else { return }

        isRoundActive = false
        dealerPlayAndResolve()
    }

    // MARK: - Helpers

    func handValue(_ hand: [Card]) -> Int {
        var total = 0
        var aces = 0

        for card in hand {
            total += card.rank.blackjackValue
            if card.rank == .ace { aces += 1 }
        }

        // Downgrade aces from 11 -> 1 while we’re busting
        while total > 21 && aces > 0 {
            total -= 10
            aces -= 1
        }

        return total
    }

    // MARK: - Private Logic

    private func dealInitialCards() {
        // 2 cards each, alternating
        if let card1 = deck.draw() { playerHand.append(card1) }
        if let card2 = deck.draw() { dealerHand.append(card2) }
        if let card3 = deck.draw() { playerHand.append(card3) }
        if let card4 = deck.draw() { dealerHand.append(card4) }
    }

    private func evaluateNaturals() {
        let playerTotal = handValue(playerHand)
        let dealerTotal = handValue(dealerHand)

        let playerNatural = playerHand.count == 2 && playerTotal == 21
        let dealerNatural = dealerHand.count == 2 && dealerTotal == 21

        guard playerNatural || dealerNatural else { return }

        isRoundActive = false

        if playerNatural && dealerNatural {
            result = .push
        } else if playerNatural {
            result = .playerWins
            showWinAnimation = true
        } else {
            result = .dealerWins
            showLoseAnimation = true
        }
    }

    private func dealerPlayAndResolve() {
        // Dealer draws until 17 or more
        while handValue(dealerHand) < 17 {
            guard let card = deck.draw() else { break }
            dealerHand.append(card)
        }

        determineOutcome()
    }

    private func determineOutcome() {
        let playerTotal = handValue(playerHand)
        let dealerTotal = handValue(dealerHand)

        if playerTotal > 21 {
            result = .dealerWins
            showLoseAnimation = true
            return
        }

        if dealerTotal > 21 {
            result = .playerWins
            showWinAnimation = true
            return
        }

        if playerTotal > dealerTotal {
            result = .playerWins
            showWinAnimation = true
        } else if dealerTotal > playerTotal {
            result = .dealerWins
            showLoseAnimation = true
        } else {
            result = .push
        }
    }
}

// MARK: - Result Enum

enum GameResult {
    case none
    case playerWins
    case dealerWins
    case push
}
