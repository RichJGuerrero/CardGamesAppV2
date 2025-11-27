import SwiftUI

@main
struct CardGamesAppV2App: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                MainMenuView()
                    .navigationDestination(for: GameType.self) { game in
                        switch game {
                        case .blackjack:
                            BlackjackView(viewModel: BlackjackViewModel())
                        }
                    }
            }
        }
    }
}
