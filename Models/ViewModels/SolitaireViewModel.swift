//
//  SolitaireViewModel.swift
//  CardGamesAppV2
//

import Foundation

class SolitaireViewModel: ObservableObject {
    @Published var gameMessage: String = "Solitaire - Coming Soon"
    
    // Placeholder for future implementation
    // Will include tableau, foundation, stock pile logic
    
    func startGame() {
        gameMessage = "Game started - implement Klondike logic here"
    }
}
