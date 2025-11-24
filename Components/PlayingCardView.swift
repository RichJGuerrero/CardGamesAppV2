import SwiftUI

struct PlayingCardView: View {
    let rank: Rank
    let suit: Suit
    
    private var suitColor: Color {
        switch suit {
        case .hearts, .diamonds:
            return .red
        default:
            return .black
        }
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(radius: 4)

            VStack(spacing: 0) {
                
                // HEADER CORNER RANK/SUIT
                HStack {
                    VStack(alignment: .leading, spacing: 0) {
                        Text(rank.rawValue)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(suitColor)
                            .minimumScaleFactor(0.1)
                            .lineLimit(1)
                        
                        Text(suit.rawValue)
                            .font(.system(size: 18))
                            .minimumScaleFactor(0.1)
                            .lineLimit(1)
                    }
                    Spacer()
                }
                
                Spacer()
                
                // CENTER SUIT
                Text(suit.rawValue)
                    .font(.system(size: 36))
                    .minimumScaleFactor(0.1)
                    .lineLimit(1)
                
                Spacer()
                
                // BOTTOM-RIGHT RANK/SUIT
                HStack {
                    Spacer()
                    VStack(alignment: .trailing, spacing: 0) {
                        Text(rank.rawValue)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(suitColor)
                            .minimumScaleFactor(0.1)
                            .lineLimit(1)
                        
                        Text(suit.rawValue)
                            .font(.system(size: 18))
                            .minimumScaleFactor(0.1)
                            .lineLimit(1)
                    }
                }
            }
            .padding(6)
        }
        .frame(width: 70, height: 100)          // Hard limit
        .contentShape(Rectangle())
        .clipped()                              // Prevent expansion
        .fixedSize()                            // Prevent flexible expansion
    }
}
