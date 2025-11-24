//
//  SolitaireView.swift
//  CardGamesAppV2
//

import SwiftUI

struct SolitaireView: View {
    @StateObject private var viewModel = SolitaireViewModel()
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.green.opacity(0.5), Color.green.opacity(0.8)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text(viewModel.gameMessage)
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding()
                
                Text("Klondike Solitaire implementation coming soon")
                    .font(.title3)
                    .foregroundColor(.white.opacity(0.8))
                    .padding()
                
                Button(action: {
                    viewModel.startGame()
                }) {
                    Text("Start (Placeholder)")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
        }
        .navigationTitle("Solitaire")
        .navigationBarTitleDisplayMode(.inline)
    }
}
