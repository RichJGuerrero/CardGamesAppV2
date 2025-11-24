import SwiftUI

struct BlackjackView: View {
    @StateObject private var viewModel = BlackjackViewModel()
    
    var body: some View {
        ZStack {
            // Green felt background
            LinearGradient(
                colors: [Color.green.opacity(0.9), Color.green.opacity(0.6)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 24) {
                
                // Status / message
                Text(viewModel.gameMessage)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top)
                
                // ======================================
                // MARK: Dealer Section
                // ======================================
                VStack(spacing: 12) {
                    
                    Text("Dealer: \(viewModel.showDealerSecondCard ? "\(viewModel.dealerHand.value)" : "?")")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    HStack(spacing: 10) {
                        ForEach(
                            Array(viewModel.dealerHand.cards.enumerated()),
                            id: \.element.id
                        ) { index, card in
                            
                            if index == 1 && !viewModel.showDealerSecondCard {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.gray)
                                    .frame(width: 70, height: 100)
                                    .fixedSize()
                            } else {
                                PlayingCardView(rank: card.rank, suit: card.suit)
                                    .frame(width: 70, height: 100)
                                    .fixedSize()
                            }
                        }
                    }
                    .frame(height: 100)  // Prevent dealer area from stretching
                }
                
                Spacer()
                
                // ======================================
                // MARK: Player Section
                // ======================================
                VStack(spacing: 12) {
                    Text("You: \(viewModel.playerHand.value)")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    HStack(spacing: 10) {
                        ForEach(viewModel.playerHand.cards) { card in
                            PlayingCardView(rank: card.rank, suit: card.suit)
                                .frame(width: 70, height: 100)
                                .fixedSize()
                        }
                    }
                    .frame(height: 100)  // Prevent player area from stretching
                }
                
                Spacer()
                
                // ======================================
                // MARK: Action Buttons
                // ======================================
                HStack(spacing: 16) {
                    
                    Button(action: { viewModel.deal() }) {
                        Text("Deal")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(viewModel.isGameActive ? Color.gray : Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .disabled(viewModel.isGameActive)
                    
                    Button(action: { viewModel.hit() }) {
                        Text("Hit")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(viewModel.isGameActive ? Color.blue : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .disabled(!viewModel.isGameActive)
                    
                    Button(action: { viewModel.stand() }) {
                        Text("Stand")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(viewModel.isGameActive ? Color.blue : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .disabled(!viewModel.isGameActive)
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            .padding(.horizontal)
        }
        .navigationTitle("Blackjack")
    }
}
