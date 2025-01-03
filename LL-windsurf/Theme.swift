import SwiftUI

enum Theme {
    static let primaryColor = Color(.systemBackground)
    static let secondaryColor = Color(.systemBlue)
    static let accentColor = Color(.systemGray5)
    static let backgroundColor = Color(.systemGroupedBackground)
    static let textColor = Color(.label)
    static let secondaryTextColor = Color(.secondaryLabel)
    
    static let titleFont = Font.system(size: 28, weight: .bold, design: .rounded)
    static let headlineFont = Font.system(size: 17, weight: .semibold, design: .rounded)
    static let bodyFont = Font.system(size: 15, weight: .regular, design: .rounded)
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(Theme.secondaryColor)
            .foregroundColor(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}
