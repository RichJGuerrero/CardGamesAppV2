import SwiftUI

struct PlayingCardView: View {

    let card: Card

    // MARK: - Premium Color Palette
    private let goldTop = Color(red: 255/255, green: 215/255, blue: 120/255)
    private let goldBottom = Color(red: 184/255, green: 134/255, blue: 11/255)
    private let cardFace = Color(red: 5/255, green: 5/255, blue: 5/255) // near jet-black
    private let rubyRed = Color(red: 225/255, green: 42/255, blue: 55/255)

    private var pipColor: Color {
        card.suit.isRed ? rubyRed : goldBottom
    }

    private var rankColor: Color {
        card.suit.isRed ? rubyRed : goldTop
    }

    var body: some View {
        ZStack {
            // Base card face
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [cardFace.opacity(0.98), cardFace.opacity(0.92)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .strokeBorder(
                            LinearGradient(
                                colors: [goldTop, goldBottom],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2
                        )
                )
                .shadow(color: .black.opacity(0.6), radius: 10, x: 0, y: 4)

            // Content
            VStack {
                // Top-left rank + suit
                HStack(alignment: .top, spacing: 3) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(card.rank.displayName)
                            .font(.system(size: 20, weight: .semibold, design: .serif))
                            .foregroundColor(rankColor)

                        Text(card.suit.symbol)
                            .font(.system(size: 14))
                            .foregroundColor(pipColor)
                    }
                    Spacer()
                }
                .padding(.horizontal, 8)
                .padding(.top, 8)

                Spacer()

                // Center pip
                Text(card.suit.symbol)
                    .font(.system(size: 34))
                    .foregroundColor(pipColor)

                Spacer()
            }
        }
    }
}
