import SwiftUI

/// Bespoke palette for Furtemp: warm/earthy tones distinct to this app's domain.
enum Theme {
    static let background = Color(red: 0x1A.0/255, green: 0x12.0/255, blue: 0x13.0/255)
    static let primary = Color(red: 0xB2.0/255, green: 0x3A.0/255, blue: 0x48.0/255)
    static let accent = Color(red: 0xF2.0/255, green: 0xA6.0/255, blue: 0x5A.0/255)
    static let card = Color.white
    static let textPrimary = Color.black.opacity(0.85)
    static let textSecondary = Color.black.opacity(0.55)

    static func titleFont(_ size: CGFloat = 28) -> Font {
        .system(size: size, weight: .bold, design: .rounded)
    }

    static func bodyFont(_ size: CGFloat = 16) -> Font {
        .system(size: size, weight: .regular, design: .rounded)
    }
}
