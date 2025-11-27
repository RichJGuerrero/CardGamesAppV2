import SwiftUI

struct MenuButton: View {
    let title: String
    let icon: String

    var body: some View {
        HStack(spacing: 14) {
            Text(icon)
                .font(.system(size: 28))

            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.black.opacity(0.25))
        .foregroundColor(.white)
        .cornerRadius(14)
    }
}
