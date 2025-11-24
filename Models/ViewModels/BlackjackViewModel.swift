import SwiftUI

class BlackjackViewModel: ObservableObject {

    @Published var playerHand = Hand()
    @Published var dealerHand = Hand()
    @Published var deck = Deck()

    @Published var gameMessage: String = ""
    @Published var isGameActive: Bool = false
    @Published var showDealerSecondCard: Bool = false

    // ================================
    // MARK: - DEAL
    // ================================
    func deal() {
        // Reset state
        deck.reset()
        deck.shuffle()
        playerHand.clear()
        dealerHand.clear()
        gameMessage = ""
        isGameActive = true
        showDealerSecondCard = false

        // Deal 2 cards each
        if let p1 = deck.draw(), let d1 = deck.draw(),
           let p2 = deck.draw(), let d2 = deck.draw() {

            playerHand.add(p1)
            playerHand.add(p2)
            dealerHand.add(d1)
            dealerHand.add(d2)
        }

        let playerTotal = playerHand.value
        let dealerTotal = dealerHand.value

        // Natural Blackjacks
        if playerHand.isBlackjack && dealerHand.isBlackjack {
            gameMessage = "Push!"
            isGameActive = false
            showDealerSecondCard = true
            return
        }

        if playerHand.isBlackjack {
            gameMessage = "Blackjack! You win!"
            isGameActive = false
            showDealerSecondCard = true
            return
        }

        if dealerHand.isBlackjack {
            gameMessage = "Dealer has Blackjack. You lose."
            isGameActive = false
            showDealerSecondCard = true
            return
        }

        // Otherwise the game continues
        gameMessage = "Your turn"
    }

    // ================================
    // MARK: - HIT
    // ================================
    func hit() {
        guard isGameActive else { return }

        if let card = deck.draw() {
            playerHand.add(card)
        }

        let total = playerHand.value

        // Bust
        if total > 21 {
            gameMessage = "Bust! You lose."
            isGameActive = false
            return
        }

        // Auto-stand when player hits 21
        if total == 21 {
            stand()
            return
        }
    }

    // ================================
    // MARK: - STAND
    // ================================
    func stand() {
        guard isGameActive else { return }

        showDealerSecondCard = true

        // Dealer draws until 17 or higher
        while dealerHand.value < 17 {
            if let card = deck.draw() {
                dealerHand.add(card)
            }
        }

        evaluateGame()
    }

    // ================================
    // MARK: - EVALUATION
    // ================================
    private func evaluateGame() {
        let playerTotal = playerHand.value
        let dealerTotal = dealerHand.value

        if dealerTotal > 21 {
            gameMessage = "Dealer busts! You win!"
        } else if dealerTotal > playerTotal {
            gameMessage = "Dealer wins."
        } else if dealerTotal < playerTotal {
            gameMessage = "You win!"
        } else {
            gameMessage = "Push!"
        }

        isGameActive = false
    }
}
