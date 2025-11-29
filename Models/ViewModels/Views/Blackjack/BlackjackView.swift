import SwiftUI

struct BlackjackView: View {

    @ObservedObject var viewModel: BlackjackViewModel

    @State private var revealDealerHoleCard = false
    @State private var triggerConfetti = false

    private let goldLight = Color(red: 1.0, green: 0.85, blue: 0.45)
    private let goldDark  = Color(red: 0.95, green: 0.65, blue: 0.10)

    var body: some View {
        ZStack {

            // Background
            LinearGradient(
                colors: [
                    Color.black,
                    Color(red: 0.0, green: 0.12, blue: 0.08)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 26) {

                    // MARK: - Title
                    Text("Blackjack")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [goldLight, goldDark],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .padding(.top, 30)

                    // MARK: - Dealer Section
                    VStack(spacing: 8) {
                        Text("Dealer: \(dealerLabel)")
                            .foregroundColor(.white.opacity(0.85))

                        handRow(
                            cards: viewModel.dealerHand,
                            hideHoleCard: !revealDealerHoleCard
                        )
                    }

                    // MARK: - Player Section
                    VStack(spacing: 8) {
                        Text("Player: \(viewModel.handValue(viewModel.playerHand))")
                            .foregroundColor(.white.opacity(0.85))

                        handRow(
                            cards: viewModel.playerHand,
                            hideHoleCard: false
                        )
                    }

                    // MARK: - Result + Confetti
                    ZStack {
                        resultTextSection

                        if triggerConfetti {
                            GoldConfettiEmitter()
                                .frame(width: 140, height: 140)
                                .offset(y: -10)
                                .allowsHitTesting(false)
                        }
                    }
                    .frame(height: 60) // keeps layout stable so buttons don't move

                    // MARK: - Controls
                    actionButtonsSection

                    Spacer(minLength: 40)
                }
                .padding(.horizontal)
            }
        }
        .onAppear {
            revealDealerHoleCard = false
        }
        .onChange(of: viewModel.result) { _, newValue in
            handleResultChange(newValue)
        }
    }

    // MARK: - Dealer Label Logic

    private var dealerLabel: String {
        if revealDealerHoleCard {
            return "\(viewModel.handValue(viewModel.dealerHand))"
        }
        if let first = viewModel.dealerHand.first {
            let visible = viewModel.handValue([first])
            return "\(visible) + ?"
        }
        return "?"
    }

    // MARK: - Card Row (original sizing & overlap behavior)

    @ViewBuilder
    private func handRow(cards: [Card], hideHoleCard: Bool) -> some View {
        GeometryReader { geo in
            let maxWidth = geo.size.width
            let usableWidth = maxWidth - 24

            // Original style card sizing
            let baseCardWidth = min(90, usableWidth / 4.2)
            let aspect: CGFloat = 1.45
            let cardWidth = baseCardWidth
            let cardHeight = baseCardWidth * aspect

            let count = cards.count
            let overlapStart = 5
            let shouldOverlap = count >= overlapStart

            let normalSpacing: CGFloat = 12
            let overlapSpacing: CGFloat = -cardWidth * 0.35
            let spacing = shouldOverlap ? overlapSpacing : normalSpacing

            HStack(spacing: spacing) {
                ForEach(Array(cards.enumerated()), id: \.offset) { index, card in
                    PlayingCardView(
                        card: card,
                        isFaceDown: hideHoleCard && index == 1
                    )
                    .frame(width: cardWidth, height: cardHeight)
                    .zIndex(Double(index))
                }
            }
            .frame(width: maxWidth, height: cardHeight, alignment: .center)
        }
        .frame(height: 150)
    }

    // MARK: - Result Text

    @ViewBuilder
    private var resultTextSection: some View {
        switch viewModel.result {

        case .playerWins:
            Text("You win!")
                .font(.title2.bold())
                .foregroundColor(goldLight)
                .shadow(color: goldLight.opacity(0.9), radius: 10)

        case .dealerWins:
            Text("Dealer wins")
                .font(.title2.bold())
                .foregroundColor(.red.opacity(0.9))

        case .push:
            Text("Push")
                .font(.title2.bold())
                .foregroundColor(.white.opacity(0.9))

        default:
            EmptyView()
        }
    }

    // MARK: - Controls

    private var actionButtonsSection: some View {
        VStack(spacing: 16) {

            HStack(spacing: 24) {
                Button("Hit") {
                    viewModel.hit()
                }
                .buttonStyle(GoldButtonStyle())

                Button("Stand") {
                    viewModel.stand()
                }
                .buttonStyle(GoldButtonStyle(outlined: true))
            }

            Button("New Round") {
                triggerConfetti = false
                revealDealerHoleCard = false
                viewModel.newRound()
            }
            .buttonStyle(GoldButtonStyle())
        }
    }

    // MARK: - Result Handling

    private func handleResultChange(_ result: GameResult) {

        // Reveal dealer hole card as soon as round is decided
        if result != .none {
            withAnimation(.easeInOut(duration: 0.4)) {
                revealDealerHoleCard = true
            }
        }

        // Confetti only on player win
        if result == .playerWins {
            triggerConfetti = true

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
                triggerConfetti = false
            }
        }
    }
}
