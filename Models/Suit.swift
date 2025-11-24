// Suit.swift

import SwiftUI

enum Suit: String, CaseIterable {
    case hearts   = "♥️"
    case diamonds = "♦️"
    case clubs    = "♣️"
    case spades   = "♠️"
    
    /// Color helper if you ever want it in views.
    var color: Color {
        switch self {
        case .hearts, .diamonds:
            return .red
        case .clubs, .spades:
            return .black
        }
    }
}
