import SwiftUI

struct CardTheme {
    let width: CGFloat
    let height: CGFloat
    let cornerRadius: CGFloat
    let fontSize: CGFloat
    let symbolSize: CGFloat
    let shadowRadius: CGFloat
    
    static let classic = CardTheme(
        width: 70,
        height: 100,
        cornerRadius: 8,
        fontSize: 24,
        symbolSize: 32,
        shadowRadius: 3
    )
    
    static let compact = CardTheme(
        width: 50,
        height: 70,
        cornerRadius: 6,
        fontSize: 18,
        symbolSize: 24,
        shadowRadius: 2
    )
}
