import AppState
import Foundation

// MARK: - Theme State

extension Application {
    /// The current theme name for the application, persisted in UserDefaults.
    var themeName: StoredState<String> {
        storedState(initial: "Retro Green", id: "selectedTheme")
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
    /// Gets the current theme colors based on stored theme name.
    @MainActor
    public static var current: ThemeColors {
        let storedState = Application.storedState(\.themeName)
        let themeName = storedState.value
        return Themes.all.first { $0.name == themeName } ?? Themes.retroGreen
    }

    /// Sets the current theme.
    /// - Parameter theme: The theme to set.
    @MainActor
    public static func setTheme(_ theme: ThemeColors) {
        var storedState = Application.storedState(\.themeName)
        storedState.value = theme.name
        NotificationCenter.default.post(name: .themeChanged, object: theme)
    }

    /// Sets the current theme by name string.
    /// - Parameter name: The name of the theme to set.
    @MainActor
    public static func setTheme(named name: String) {
        if let theme = Themes.all.first(where: { $0.name == name }) {
            setTheme(theme)
        }
    }
}
