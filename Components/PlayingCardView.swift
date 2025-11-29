import SwiftUI

struct PlayingCardView: View {

    let card: Card
    var isFaceDown: Bool = false

    // MARK: - Premium Color Palette
    private let goldTop = Color(red: 255/255, green: 215/255, blue: 120/255)
    private let goldBottom = Color(red: 184/255, green: 134/255, blue: 11/255)
    private let cardFace = Color(red: 5/255, green: 5/255, blue: 5/255) // near jet-black
    private let rubyRed = Color(red: 225/255, green: 42/255, blue: 55/255)

    private var pipColor: Color {
        card.suit.isRed ? rubyRed : goldBottom
    }

    var body: some View {
        ZStack {
            if isFaceDown {
                // Card back (dealer hole card)
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.black,
                                Color(red: 0.10, green: 0.10, blue: 0.10)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(
                                LinearGradient(
                                    colors: [goldTop, goldBottom],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 3
                            )
                    )
                    .overlay(
                        Image(systemName: "star.fill")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(goldTop)              // this is the “reference” gold
                            .shadow(color: goldTop.opacity(0.9), radius: 4)
                    )
            } else {
                // Card face
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [cardFace.opacity(0.98), cardFace.opacity(0.92)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(
                                LinearGradient(
                                    colors: [goldTop, goldBottom],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 3
                            )
                    )
                    .overlay(
                        VStack(alignment: .leading, spacing: 0) {
                            // Rank + small pip in top-left
                            HStack(alignment: .top, spacing: 2) {
                                Text(card.rank.displayName)
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(card.suit.isRed ? rubyRed : goldTop)
                                    .shadow(color: goldTop.opacity(0.8), radius: 1) // slim gold outline

                                Text(card.suit.symbol)
                                    .font(.system(size: 14))
                                    .foregroundColor(pipColor)
                                    .shadow(color: goldTop.opacity(0.8), radius: 1) // slim gold outline
                            }
                            .padding(.horizontal, 8)
                            .padding(.top, 8)

                            Spacer()

                            // Center pip
                            Text(card.suit.symbol)
                                .font(.system(size: 34))
                                .foregroundColor(pipColor)
                                .shadow(color: goldTop.opacity(0.9), radius: 1.2) // subtle glow

                            Spacer()
                        }
                    )
            }
        }
    }
}
