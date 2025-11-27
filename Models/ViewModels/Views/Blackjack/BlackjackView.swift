import SwiftUI

struct BlackjackView: View {

    @StateObject var viewModel: BlackjackViewModel

    // Local animation states (if you want to use later)
    @State private var animateWinShimmer = false

    // Gold RGB values from MainMenuView.swift
    private let goldTop     = Color(red: 1.0, green: 0.85, blue: 0.45)
    private let goldBottom  = Color(red: 0.95, green: 0.65, blue: 0.10)

    var body: some View {
        ZStack {

            // Casino dark felt background
            LinearGradient(
                colors: [
                    Color.black,
                    Color(red: 0.02, green: 0.18, blue: 0.10)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {

                    // Title
                    Text("Blackjack")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [goldTop, goldBottom],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .padding(.top, 24)

                    // Dealer section
                    VStack(spacing: 8) {
                        Text("Dealer: \(viewModel.handValue(viewModel.dealerHand))")
                            .foregroundColor(.white.opacity(0.9))

                        handRow(viewModel.dealerHand, isPlayer: false)
                    }

                    // Player section
                    VStack(spacing: 8) {
                        Text("Player: \(viewModel.handValue(viewModel.playerHand))")
                            .foregroundColor(.white.opacity(0.9))

                        handRow(viewModel.playerHand, isPlayer: true)
                    }

                    resultTextSection

                    actionButtonsSection

                    Spacer()
                }
                .padding(.horizontal)
            }
        }
        // 🔑 Inject the view model so the modifiers using @EnvironmentObject can see it
        .environmentObject(viewModel)
    }

    // MARK: - Card Row
    @ViewBuilder
    private func handRow(_ cards: [Card], isPlayer: Bool) -> some View {
        HStack(spacing: adjustedSpacing(for: cards.count)) {
            ForEach(cards.indices, id: \.self) { index in
                PlayingCardView(card: cards[index])
                    .frame(width: 70, height: 100)
            }
        }
        .padding(.top, 4)
        .modifier(winShimmerModifier(isPlayer: isPlayer))
        .modifier(loseShakeModifier(isPlayer: isPlayer))
    }

    private func adjustedSpacing(for count: Int) -> CGFloat {
        count <= 4 ? 12 : max(4, 12 - CGFloat(count * 1))
    }

    // MARK: - Result Text
    @ViewBuilder
    private var resultTextSection: some View {
        switch viewModel.result {
        case .playerWins:
            Text("You win!")
                .font(.title2.bold())
                .foregroundStyle(goldTop)
                .scaleEffect(viewModel.showWinAnimation ? 1.12 : 1.0)
                .shadow(color: goldTop.opacity(0.8), radius: 12)
                .animation(.spring(response: 0.4, dampingFraction: 0.5),
                           value: viewModel.showWinAnimation)

        case .dealerWins:
            Text("You busted.")
                .font(.title3.bold())
                .foregroundColor(.red)
                .offset(y: viewModel.showLoseAnimation ? 8 : -8)
                .opacity(viewModel.showLoseAnimation ? 1 : 0)
                .animation(.easeOut(duration: 0.45),
                           value: viewModel.showLoseAnimation)

        case .push:
            Text("Push.")
                .foregroundColor(.white.opacity(0.7))

        default:
            EmptyView()
        }
    }

    // MARK: - Action Buttons
    @ViewBuilder
    private var actionButtonsSection: some View {
        VStack(spacing: 10) {

            HStack(spacing: 20) {

                // Hit
                Button("Hit") {
                    viewModel.hit()
                }
                .buttonStyle(GoldButtonStyle())
                .disabled(viewModel.result != .none)

                // Stand
                Button("Stand") {
                    viewModel.stand()
                }
                .buttonStyle(GoldButtonStyle(outlined: true))
                .disabled(viewModel.result != .none)
            }

            // New Round
            Button("New Round") {
                viewModel.newRound()
            }
            .buttonStyle(GoldButtonStyle())
        }
    }
}

// MARK: - Win Shimmer
struct winShimmerModifier: ViewModifier {

    @EnvironmentObject var vm: BlackjackViewModel
    var isPlayer: Bool
    @State private var animate = false

    func body(content: Content) -> some View {
        content
            .overlay(
                Group {
                    if isPlayer && vm.showWinAnimation {
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.0),
                                Color.yellow.opacity(0.35),
                                Color.white.opacity(0.0)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .mask(
                            Rectangle()
                                .rotationEffect(.degrees(25))
                                .offset(x: animate ? 200 : -200)
                        )
                        .onAppear {
                            withAnimation(.easeOut(duration: 0.9)) {
                                animate = true
                            }
                        }
                    }
                }
            )
    }
}

// MARK: - Lose Shake
struct loseShakeModifier: ViewModifier {

    @EnvironmentObject var vm: BlackjackViewModel
    var isPlayer: Bool

    func body(content: Content) -> some View {
        content
            .modifier(
                ShakeEffect(times: vm.showLoseAnimation && isPlayer ? 3 : 0)
            )
    }
}

// MARK: - Shake Effect
struct ShakeEffect: GeometryEffect {
    var times: CGFloat
    var amount: CGFloat = 8
    var animatableData: CGFloat

    init(times: CGFloat) {
        self.times = times
        self.animatableData = times
    }

    func effectValue(size: CGSize) -> ProjectionTransform {
        let translation = amount * sin(animatableData * .pi * 2)
        return ProjectionTransform(
            CGAffineTransform(translationX: translation, y: 0)
        )
    }
}
