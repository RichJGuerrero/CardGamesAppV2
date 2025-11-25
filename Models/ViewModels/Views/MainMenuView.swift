//
//  MainMenuView.swift
//  CardGamesAppV2
//

import SwiftUI

struct MainMenuView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                Text("Card Games")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(.white)
                
                VStack(spacing: 20) {
                    NavigationLink(value: GameType.blackjack) {
                        MenuButton(title: "Blackjack", icon: "🃏")
                    }
                    
                    NavigationLink(value: GameType.solitaire) {
                        MenuButton(title: "Solitaire", icon: "🂡")
                    }
                    
                    NavigationLink(value: GameType.poker) {
                        MenuButton(title: "Poker", icon: "🂠")
                    }
                }
                .padding(.horizontal)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                LinearGradient(
                    colors: [Color.green.opacity(0.8), Color.green.opacity(0.4)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
            )
            .navigationDestination(for: GameType.self) { gameType in
                switch gameType {
                case .blackjack:
                    BlackjackView(viewModel: BlackjackViewModel())
                case .solitaire:
                    SolitaireView()
                case .poker:
                    PokerPlaceholderView()
                }
            }
        }
    }
}

struct MenuButton: View {
    let title: String
    let icon: String
    
    var body: some View {
        HStack {
            Text(icon)
                .font(.system(size: 40))
            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .foregroundColor(.black)
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}

struct PokerPlaceholderView: View {
    var body: some View {
        VStack {
            Text("🂠")
                .font(.system(size: 100))
            Text("Poker")
                .font(.largeTitle)
            Text("Coming Soon")
                .font(.title3)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.green.opacity(0.3))
    }
}
