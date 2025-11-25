import SwiftUI

struct PlayingCardView: View {
    let card: Card

    private var foregroundColor: Color {
        // assuming Suit has a `color` property like `.red` / `.black`
        card.suit.color == .red ? .red : .black
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(radius: 4)

            VStack {
                HStack {
                    Text(card.rank.displayName)
                        .font(.headline)
                        .foregroundColor(foregroundColor)
                    Spacer()
                    Text(card.suit.symbol)
                        .font(.headline)
                        .foregroundColor(foregroundColor)
                }
                Spacer()
                Text(card.suit.symbol)
                    .font(.largeTitle)
                    .foregroundColor(foregroundColor)
                Spacer()
                HStack {
                    Text(card.suit.symbol)
                        .font(.headline)
                        .foregroundColor(foregroundColor)
                    Spacer()
                    Text(card.rank.displayName)
                        .font(.headline)
                        .foregroundColor(foregroundColor)
                }
            }
            .padding(8)
        }
    }
}
