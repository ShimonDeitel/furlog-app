import SwiftUI

/// Unique visual identity for Furlog.
enum Theme {
    static let background = Color(red: 0.169, green: 0.118, blue: 0.141)
    static let accent = Color(red: 0.914, green: 0.478, blue: 0.612)
    static let secondary = Color(red: 0.851, green: 0.663, blue: 0.722)
    static let cardBackground = background.opacity(0.92)

    static let titleFont = Font.system(.title2, design: .serif).weight(.bold)
    static let headlineFont = Font.system(.headline, design: .serif).weight(.semibold)
    static let bodyFont = Font.system(.body, design: .serif)
    static let captionFont = Font.system(.caption, design: .serif)

    static let cornerRadius: CGFloat = 16
    static let spacing: CGFloat = 12
}
