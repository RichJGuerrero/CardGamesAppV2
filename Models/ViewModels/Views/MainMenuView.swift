import SwiftUI

struct MainMenuView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 32) {

                Spacer(minLength: 40)

                // Title
                Text("Pocket Blackjack")
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [
                                Color(red: 1.0, green: 0.85, blue: 0.45),
                                Color(red: 0.95, green: 0.65, blue: 0.10)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: Color.black.opacity(0.6), radius: 6, x: 0, y: 4)

                // Subtitle
                Text("A clean, premium take on the classic casino game.")
                    .font(.subheadline)
                    .foregroundColor(Color.white.opacity(0.75))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)

                // Play button
                VStack(spacing: 20) {
                    NavigationLink {
                        BlackjackView(viewModel: BlackjackViewModel())
                    } label: {
                        MenuButton(title: "Play Blackjack", icon: "♠︎")
                    }
                }
                .padding(.horizontal)

                Spacer()

                // Footer
                Text("Micro Interactive • v1.0")
                    .font(.caption)
                    .foregroundColor(Color.white.opacity(0.5))
                    .padding(.bottom, 16)
            }
            .background(
                LinearGradient(
                    colors: [
                        Color.black,
                        Color(red: 0.0, green: 0.12, blue: 0.08)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            )
        }
    }
}
