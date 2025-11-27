import SwiftUI

struct GoldButtonStyle: ButtonStyle {

    var outlined: Bool = false

    // Gold RGB colors used throughout the app
    private let goldTop     = Color(red: 1.0, green: 0.85, blue: 0.45)
    private let goldBottom  = Color(red: 0.95, green: 0.65, blue: 0.10)

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 18, weight: .semibold))
            .padding(.horizontal, 22)
            .padding(.vertical, 12)
            .background(background(configuration))
            .foregroundColor(textColor)
            .overlay(borderOverlay)
            .cornerRadius(12)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7),
                       value: configuration.isPressed)
    }

    // MARK: - Backgrounds

    @ViewBuilder
    private func background(_ configuration: Configuration) -> some View {
        if outlined {
            Color.clear
        } else {
            LinearGradient(
                colors: [
                    configuration.isPressed ? goldBottom : goldTop,
                    configuration.isPressed ? goldTop : goldBottom
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }

    // MARK: - Text
    private var textColor: Color {
        outlined ? Color(red: 1.0, green: 0.85, blue: 0.45) : Color.black
    }

    // MARK: - Border
    private var borderOverlay: some View {
        RoundedRectangle(cornerRadius: 12)
            .stroke(
                LinearGradient(
                    colors: [goldTop, goldBottom],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                lineWidth: outlined ? 2 : 0
            )
    }
}
