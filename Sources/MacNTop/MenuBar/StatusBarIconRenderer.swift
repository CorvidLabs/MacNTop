import AppKit

/// Renders the status bar icon with dynamic CPU and memory bars.
public final class StatusBarIconRenderer: Sendable {
    // MARK: - Constants

    private let iconSize = NSSize(width: 32, height: 18)
    private let barWidth: CGFloat = 6
    private let barSpacing: CGFloat = 2
    private let barCornerRadius: CGFloat = 1

    // MARK: - Colors

    private var cpuColor: NSColor {
        NSColor.systemBlue
    }

    private var memoryColor: NSColor {
        NSColor.systemGreen
    }

    private var backgroundColor: NSColor {
        NSColor.gray.withAlphaComponent(0.3)
    }

    // MARK: - Public Methods

    /// Renders an icon with the given CPU and memory usage percentages.
    /// - Parameters:
    ///   - cpuUsage: CPU usage percentage (0-100).
    ///   - memoryUsage: Memory usage percentage (0-100).
    /// - Returns: An NSImage suitable for the status bar.
    public func renderIcon(cpuUsage: Double, memoryUsage: Double) -> NSImage {
        let image = NSImage(size: iconSize)
        image.lockFocus()

        let cpuRect = NSRect(
            x: 4,
            y: 2,
            width: barWidth,
            height: iconSize.height - 4
        )

        let memRect = NSRect(
            x: cpuRect.maxX + barSpacing,
            y: 2,
            width: barWidth,
            height: iconSize.height - 4
        )

        drawBar(in: cpuRect, fillPercent: cpuUsage / 100, color: cpuColor)
        drawBar(in: memRect, fillPercent: memoryUsage / 100, color: memoryColor)

        image.unlockFocus()
        image.isTemplate = false

        return image
    }

    /// Renders a static placeholder icon.
    public func renderPlaceholderIcon() -> NSImage {
        renderIcon(cpuUsage: 0, memoryUsage: 0)
    }

    // MARK: - Private Methods

    private func drawBar(in rect: NSRect, fillPercent: Double, color: NSColor) {
        let clampedPercent = min(max(fillPercent, 0), 1)

        let backgroundPath = NSBezierPath(roundedRect: rect, xRadius: barCornerRadius, yRadius: barCornerRadius)
        backgroundColor.setFill()
        backgroundPath.fill()

        let fillHeight = rect.height * CGFloat(clampedPercent)
        let fillRect = NSRect(
            x: rect.origin.x,
            y: rect.origin.y,
            width: rect.width,
            height: fillHeight
        )

        let fillPath = NSBezierPath(roundedRect: fillRect, xRadius: barCornerRadius, yRadius: barCornerRadius)
        color.setFill()
        fillPath.fill()
    }
}
