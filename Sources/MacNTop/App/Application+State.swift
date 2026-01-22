import AppState
import Foundation

// MARK: - Theme Enum

/// Available themes for the application.
public enum Theme: String, CaseIterable, Sendable, Codable {
    case retroGreen = "Retro Green"
    case amber = "Amber CRT"
    case blueIce = "Blue Ice"
    case matrix = "Matrix"
    case dracula = "Dracula"
    case light = "Light"

    /// The corresponding ThemeColors for this theme.
    public var colors: ThemeColors {
        switch self {
        case .retroGreen: return Themes.retroGreen
        case .amber: return Themes.amber
        case .blueIce: return Themes.blueIce
        case .matrix: return Themes.matrix
        case .dracula: return Themes.dracula
        case .light: return Themes.light
        }
    }

    /// Creates a Theme from a ThemeColors instance.
    public init?(from colors: ThemeColors) {
        guard let theme = Theme.allCases.first(where: { $0.colors.name == colors.name }) else {
            return nil
        }
        self = theme
    }
}

// MARK: - Theme State

extension Application {
    /// The current theme for the application, persisted in UserDefaults.
    var theme: StoredState<Theme> {
        storedState(initial: .retroGreen, id: "selectedTheme")
    }
}

// MARK: - Notification Names

extension Notification.Name {
    /// Posted when the theme changes.
    static let themeChanged = Notification.Name("ThemeChanged")
}

// MARK: - Theme Accessor

/// Provides convenient access to the current theme colors using AppState.
public enum AppTheme {
    /// Gets the current theme colors based on stored theme.
    @MainActor
    public static var current: ThemeColors {
        Application.storedState(\.theme).value.colors
    }

    /// Gets the current theme enum value.
    @MainActor
    public static var currentTheme: Theme {
        Application.storedState(\.theme).value
    }

    /// Sets the current theme.
    /// - Parameter theme: The theme to set.
    @MainActor
    public static func setTheme(_ theme: Theme) {
        var storedState = Application.storedState(\.theme)
        storedState.value = theme
        NotificationCenter.default.post(name: .themeChanged, object: theme.colors)
    }

    /// Sets the current theme from ThemeColors.
    /// - Parameter colors: The theme colors to set.
    @MainActor
    public static func setTheme(_ colors: ThemeColors) {
        if let theme = Theme(from: colors) {
            setTheme(theme)
        }
    }
}
