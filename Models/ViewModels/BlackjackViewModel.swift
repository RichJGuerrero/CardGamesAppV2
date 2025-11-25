import Foundation
import SwiftUI

final class BlackjackViewModel: ObservableObject {

    @Published private(set) var game = BlackjackGame()

    // Animation trigger
    @Published var animateCards: Bool = false

    var playerCards: [Card] { game.playerHand }
    var dealerCards: [Card] { game.dealerHand }

    var playerValueText: String {
        "Player: \(game.playerValue)"
    }

    var dealerValueText: String {
        "Dealer: \(game.dealerValue)"
    }

    var statusText: String {
        switch game.result {
        case .none:
            return game.isPlayerTurn ? "Your move" : "Dealer's turn"
        case .playerBlackjack:
            return "Blackjack! You win."
        case .dealerBlackjack:
            return "Dealer Blackjack."
        case .playerBust:
            return "You busted."
        case .dealerBust:
            return "Dealer busts! You win."
        case .playerWins:
            return "You win."
        case .dealerWins:
            return "Dealer wins."
        case .push:
            return "Push."
        }
    }

    var canHit: Bool { game.canHit }
    var canStand: Bool { game.canStand }

    // MARK: Game Actions

    func start() {
        animateCards = false
        game.startNewRound()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            withAnimation(.easeOut(duration: 0.4)) {
                self.animateCards = true
            }
        }

        objectWillChange.send()
    }

    func hit() {
        game.playerHit()
        animateNewCard()
        objectWillChange.send()
    }

    func stand() {
        game.playerStand()
        objectWillChange.send()
    }

    func newRound() {
        start()
    }

    private func animateNewCard() {
        animateCards = false

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            withAnimation(.easeOut(duration: 0.4)) {
                self.animateCards = true
            }
        }
    }
}
