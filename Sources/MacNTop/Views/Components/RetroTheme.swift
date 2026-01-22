import AppKit

// MARK: - Theme Definition

/// Defines colors for a theme.
public struct ThemeColors: Sendable, Equatable {
    public let name: String
    public let background: NSColor
    public let primaryText: NSColor
    public let secondaryText: NSColor
    public let accent: NSColor
    public let warning: NSColor
    public let critical: NSColor
    public let barBackground: NSColor
    public let separator: NSColor
}

// MARK: - Theme Definitions

public enum Themes {
    /// Classic green phosphor CRT.
    public static let retroGreen = ThemeColors(
        name: "Retro Green",
        background: NSColor(calibratedRed: 0.02, green: 0.02, blue: 0.04, alpha: 1.0),
        primaryText: NSColor(calibratedRed: 0.2, green: 1.0, blue: 0.4, alpha: 1.0),
        secondaryText: NSColor(calibratedRed: 0.1, green: 0.5, blue: 0.25, alpha: 1.0),
        accent: NSColor(calibratedRed: 0.3, green: 1.0, blue: 1.0, alpha: 1.0),
        warning: NSColor(calibratedRed: 1.0, green: 0.8, blue: 0.1, alpha: 1.0),
        critical: NSColor(calibratedRed: 1.0, green: 0.2, blue: 0.2, alpha: 1.0),
        barBackground: NSColor(calibratedRed: 0.08, green: 0.08, blue: 0.1, alpha: 1.0),
        separator: NSColor(calibratedRed: 0.15, green: 0.25, blue: 0.2, alpha: 1.0)
    )

    /// Amber/orange phosphor terminal.
    public static let amber = ThemeColors(
        name: "Amber CRT",
        background: NSColor(calibratedRed: 0.04, green: 0.02, blue: 0.0, alpha: 1.0),
        primaryText: NSColor(calibratedRed: 1.0, green: 0.7, blue: 0.2, alpha: 1.0),
        secondaryText: NSColor(calibratedRed: 0.6, green: 0.4, blue: 0.1, alpha: 1.0),
        accent: NSColor(calibratedRed: 1.0, green: 0.85, blue: 0.4, alpha: 1.0),
        warning: NSColor(calibratedRed: 1.0, green: 0.5, blue: 0.1, alpha: 1.0),
        critical: NSColor(calibratedRed: 1.0, green: 0.2, blue: 0.1, alpha: 1.0),
        barBackground: NSColor(calibratedRed: 0.1, green: 0.06, blue: 0.02, alpha: 1.0),
        separator: NSColor(calibratedRed: 0.3, green: 0.2, blue: 0.1, alpha: 1.0)
    )

    /// Cool blue terminal.
    public static let blueIce = ThemeColors(
        name: "Blue Ice",
        background: NSColor(calibratedRed: 0.02, green: 0.04, blue: 0.08, alpha: 1.0),
        primaryText: NSColor(calibratedRed: 0.4, green: 0.8, blue: 1.0, alpha: 1.0),
        secondaryText: NSColor(calibratedRed: 0.2, green: 0.4, blue: 0.6, alpha: 1.0),
        accent: NSColor(calibratedRed: 0.6, green: 0.9, blue: 1.0, alpha: 1.0),
        warning: NSColor(calibratedRed: 1.0, green: 0.8, blue: 0.3, alpha: 1.0),
        critical: NSColor(calibratedRed: 1.0, green: 0.3, blue: 0.4, alpha: 1.0),
        barBackground: NSColor(calibratedRed: 0.05, green: 0.08, blue: 0.12, alpha: 1.0),
        separator: NSColor(calibratedRed: 0.1, green: 0.2, blue: 0.3, alpha: 1.0)
    )

    /// Bright green Matrix style.
    public static let matrix = ThemeColors(
        name: "Matrix",
        background: NSColor(calibratedRed: 0.0, green: 0.0, blue: 0.0, alpha: 1.0),
        primaryText: NSColor(calibratedRed: 0.0, green: 1.0, blue: 0.0, alpha: 1.0),
        secondaryText: NSColor(calibratedRed: 0.0, green: 0.5, blue: 0.0, alpha: 1.0),
        accent: NSColor(calibratedRed: 0.5, green: 1.0, blue: 0.5, alpha: 1.0),
        warning: NSColor(calibratedRed: 0.8, green: 1.0, blue: 0.0, alpha: 1.0),
        critical: NSColor(calibratedRed: 1.0, green: 0.0, blue: 0.0, alpha: 1.0),
        barBackground: NSColor(calibratedRed: 0.0, green: 0.1, blue: 0.0, alpha: 1.0),
        separator: NSColor(calibratedRed: 0.0, green: 0.3, blue: 0.0, alpha: 1.0)
    )

    /// Dracula purple/pink theme.
    public static let dracula = ThemeColors(
        name: "Dracula",
        background: NSColor(calibratedRed: 0.16, green: 0.16, blue: 0.21, alpha: 1.0),
        primaryText: NSColor(calibratedRed: 0.97, green: 0.97, blue: 0.95, alpha: 1.0),
        secondaryText: NSColor(calibratedRed: 0.38, green: 0.45, blue: 0.55, alpha: 1.0),
        accent: NSColor(calibratedRed: 0.74, green: 0.58, blue: 0.98, alpha: 1.0),
        warning: NSColor(calibratedRed: 1.0, green: 0.72, blue: 0.42, alpha: 1.0),
        critical: NSColor(calibratedRed: 1.0, green: 0.33, blue: 0.47, alpha: 1.0),
        barBackground: NSColor(calibratedRed: 0.2, green: 0.2, blue: 0.27, alpha: 1.0),
        separator: NSColor(calibratedRed: 0.3, green: 0.3, blue: 0.4, alpha: 1.0)
    )

    /// Light mode for daytime.
    public static let light = ThemeColors(
        name: "Light",
        background: NSColor(calibratedRed: 0.95, green: 0.95, blue: 0.97, alpha: 1.0),
        primaryText: NSColor(calibratedRed: 0.1, green: 0.1, blue: 0.1, alpha: 1.0),
        secondaryText: NSColor(calibratedRed: 0.4, green: 0.4, blue: 0.45, alpha: 1.0),
        accent: NSColor(calibratedRed: 0.0, green: 0.5, blue: 0.8, alpha: 1.0),
        warning: NSColor(calibratedRed: 0.9, green: 0.6, blue: 0.0, alpha: 1.0),
        critical: NSColor(calibratedRed: 0.9, green: 0.2, blue: 0.2, alpha: 1.0),
        barBackground: NSColor(calibratedRed: 0.85, green: 0.85, blue: 0.87, alpha: 1.0),
        separator: NSColor(calibratedRed: 0.75, green: 0.75, blue: 0.78, alpha: 1.0)
    )

    /// All available themes.
    public static let all: [ThemeColors] = [retroGreen, amber, blueIce, matrix, dracula, light]
}

// MARK: - RetroTheme (Convenience Access)

/// Convenience access to current theme colors.
/// Uses AppState for persistence and state management.
public enum RetroTheme {
    // MARK: - Colors (Dynamic via AppState)

    @MainActor public static var background: NSColor { Theme.current.colors.background }
    @MainActor public static var primaryText: NSColor { Theme.current.colors.primaryText }
    @MainActor public static var secondaryText: NSColor { Theme.current.colors.secondaryText }
    @MainActor public static var accent: NSColor { Theme.current.colors.accent }
    @MainActor public static var warning: NSColor { Theme.current.colors.warning }
    @MainActor public static var critical: NSColor { Theme.current.colors.critical }
    @MainActor public static var barBackground: NSColor { Theme.current.colors.barBackground }
    @MainActor public static var separator: NSColor { Theme.current.colors.separator }

    // MARK: - Glow Colors

    @MainActor public static var glowGreen: NSColor { primaryText.withAlphaComponent(0.9) }
    @MainActor public static var glowCyan: NSColor { accent.withAlphaComponent(0.9) }

    // MARK: - Fonts

    @MainActor
    public static func monoFont(size: CGFloat, weight: NSFont.Weight = .regular) -> NSFont {
        if let font = NSFont(name: "Monaco", size: size) {
            return font
        }
        if let font = NSFont(name: "Menlo", size: size) {
            return font
        }
        return NSFont.monospacedSystemFont(ofSize: size, weight: weight)
    }

    @MainActor public static var smallMono: NSFont { monoFont(size: 10) }
    @MainActor public static var regularMono: NSFont { monoFont(size: 11) }
    @MainActor public static var largeMono: NSFont { monoFont(size: 12, weight: .medium) }

    // MARK: - Block Characters

    public static let blockFull = "█"
    public static let blockHigh = "▓"
    public static let blockMed = "▒"
    public static let blockLow = "░"
    public static let blockEmpty = " "

    // MARK: - ASCII Progress Bar

    public static func asciiBar(percent: Double, width: Int = 20) -> String {
        let exactFilled = (percent / 100.0) * Double(width)
        let wholeFilled = Int(exactFilled)
        let remainder = exactFilled - Double(wholeFilled)

        var bar = String(repeating: blockFull, count: max(0, min(wholeFilled, width)))

        if wholeFilled < width {
            if remainder > 0.75 {
                bar += blockHigh
            } else if remainder > 0.5 {
                bar += blockMed
            } else if remainder > 0.25 {
                bar += blockLow
            }
        }

        let currentLength = bar.count
        if currentLength < width {
            bar += String(repeating: blockLow, count: width - currentLength)
        }

        return bar
    }

    public static func simpleBar(percent: Double, width: Int = 20) -> String {
        let filled = Int((percent / 100.0) * Double(width))
        let empty = width - filled
        return String(repeating: blockFull, count: max(0, filled)) +
               String(repeating: blockLow, count: max(0, empty))
    }

    @MainActor
    public static func colorForUsage(_ percent: Double) -> NSColor {
        switch percent {
        case 0..<50: return primaryText
        case 50..<80: return warning
        default: return critical
        }
    }

    // MARK: - Shadow/Glow Effect

    @MainActor
    public static func glowShadow(color: NSColor? = nil) -> NSShadow {
        let shadow = NSShadow()
        shadow.shadowColor = (color ?? primaryText).withAlphaComponent(0.7)
        shadow.shadowBlurRadius = 4
        shadow.shadowOffset = NSSize(width: 0, height: 0)
        return shadow
    }

    @MainActor
    public static func applyGlow(to textField: NSTextField, color: NSColor? = nil) {
        textField.shadow = glowShadow(color: color)
    }
}
