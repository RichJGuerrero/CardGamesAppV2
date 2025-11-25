import Foundation
import SwiftUI

enum Suit: String, CaseIterable {
    case hearts = "♥"
    case diamonds = "♦"
    case clubs = "♣"
    case spades = "♠"

    var symbol: String {
        return self.rawValue
    }

    var color: Color {
        switch self {
        case .hearts, .diamonds:
            return .red
        default:
            return .black
        }
    }
}
