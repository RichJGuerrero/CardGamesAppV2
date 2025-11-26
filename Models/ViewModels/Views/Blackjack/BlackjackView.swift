import SwiftUI

struct BlackjackView: View {
    @StateObject var viewModel: BlackjackViewModel

    private let cardWidth: CGFloat = 70
    private let cardHeight: CGFloat = 100

    // Deck origin (top center, slightly off screen)
    private var deckOrigin: CGPoint {
        CGPoint(
            x: UIScreen.main.bounds.width / 2 - (cardWidth / 2),
            y: -cardHeight - 20
        )
    }

    var body: some View {
        VStack(spacing: 16) {

            // Title
            Text("Blackjack")
                .font(.largeTitle.bold())
                .foregroundColor(.white)
                .padding(.top, 10)

            // DEALER SECTION
            VStack(alignment: .leading, spacing: 8) {
                Text(viewModel.dealerValueText)
                    .font(.headline)
                    .foregroundColor(.white)

                ScrollView(.horizontal, showsIndicators: false) {
                    let cards = viewModel.dealerCards
                    let count = CGFloat(cards.count)

                    let scale: CGFloat = {
                        switch count {
                        case 0...5:   return 1.0
                        case 6...7:   return 0.85
                        case 8...9:   return 0.72
                        case 10...12: return 0.62
                        default:      return 0.52
                        }
                    }()

                    let spacing: CGFloat = {
                        switch count {
                        case 0...5:   return 8
                        case 6...7:   return 6
                        case 8...9:   return 4
                        case 10...12: return 3
                        default:      return 2
                        }
                    }()

                    LazyHStack(spacing: spacing) {
                        ForEach(cards.indices, id: \.self) { index in
                            let card = cards[index]
                            animatedCard(card)
                                .scaleEffect(scale)
                        }
                    }
                    .padding(.vertical, 8)     // prevents vertical clipping
                }
                .frame(height: cardHeight * 1.25)  // ensures ScrollView retains enough height
            }
            .padding(.horizontal)

            // PLAYER SECTION
            VStack(alignment: .leading, spacing: 8) {
                Text(viewModel.playerValueText)
                    .font(.headline)
                    .foregroundColor(.white)

                ScrollView(.horizontal, showsIndicators: false) {
                    let cards = viewModel.playerCards
                    let count = CGFloat(cards.count)

                    let scale: CGFloat = {
                        switch count {
                        case 0...5:   return 1.0
                        case 6...7:   return 0.85
                        case 8...9:   return 0.72
                        case 10...12: return 0.62
                        default:      return 0.52
                        }
                    }()

                    let spacing: CGFloat = {
                        switch count {
                        case 0...5:   return 8
                        case 6...7:   return 6
                        case 8...9:   return 4
                        case 10...12: return 3
                        default:      return 2
                        }
                    }()

                    LazyHStack(spacing: spacing) {
                        ForEach(cards.indices, id: \.self) { index in
                            let card = cards[index]
                            animatedCard(card)
                                .scaleEffect(scale)
                        }
                    }
                    .padding(.vertical, 8)
                }
                .frame(height: cardHeight * 1.25)
            }
            .padding(.horizontal)

            // STATUS
            Text(viewModel.statusText)
                .font(.subheadline)
                .foregroundColor(.white)
                .padding(.top, 4)

            // ACTION BUTTONS
            HStack(spacing: 20) {

                Button("Hit") {
                    viewModel.hit()
                }
                .buttonStyle(.borderedProminent)
                .tint(.yellow)
                .disabled(!viewModel.canHit)

                Button("Stand") {
                    viewModel.stand()
                }
                .buttonStyle(.borderedProminent)
                .tint(.orange)
                .disabled(!viewModel.canStand)
            }

            Button("New Round") {
                viewModel.newRound()
            }
            .buttonStyle(.borderedProminent)
            .tint(.blue.opacity(0.85))
            .padding(.top, 4)

            Spacer()
        }
        .padding()
        .background(
            LinearGradient(
                colors: [Color.green.opacity(0.8), Color.green.opacity(0.4)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        )
        .onAppear {
            viewModel.start()
        }
    }

    // MARK: - Animated Card Builder
    private func animatedCard(_ card: Card) -> some View {
        PlayingCardView(card: card)
            .frame(width: cardWidth, height: cardHeight)
            .offset(
                x: viewModel.animateCards ? 0 : (deckOrigin.x - 50),
                y: viewModel.animateCards ? 0 : (deckOrigin.y - 50)
            )
            .rotationEffect(.degrees(viewModel.animateCards ? 0 : 20))
            .animation(.easeOut(duration: 0.40), value: viewModel.animateCards)
    }
}

// temp change
