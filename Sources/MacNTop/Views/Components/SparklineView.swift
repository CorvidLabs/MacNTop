import AppKit

/// A retro-styled mini line graph view with pixel aesthetic.
public final class SparklineView: NSView {
    // MARK: - Properties

    private var values: [Double] = []
    private var lineColor: NSColor = RetroTheme.primaryText

    // MARK: - Configuration

    /// Sets the data values to display.
    public func setValues(_ newValues: [Double], color: NSColor = RetroTheme.primaryText) {
        values = newValues
        lineColor = color
        needsDisplay = true
    }

    // MARK: - Drawing

    public override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Draw background
        RetroTheme.barBackground.setFill()
        NSBezierPath(rect: bounds).fill()

        guard values.count >= 2 else {
            drawEmptyState(in: bounds)
            drawBorder()
            return
        }

        let maxValue = max(values.max() ?? 100, 1)
        let padding: CGFloat = 2

        let path = NSBezierPath()
        let fillPath = NSBezierPath()

        let drawWidth = bounds.width - padding * 2
        let drawHeight = bounds.height - padding * 2
        let stepX = drawWidth / CGFloat(values.count - 1)

        for (index, value) in values.enumerated() {
            let x = padding + CGFloat(index) * stepX
            let y = padding + CGFloat(value / maxValue) * drawHeight

            if index == 0 {
                path.move(to: NSPoint(x: x, y: y))
                fillPath.move(to: NSPoint(x: x, y: padding))
                fillPath.line(to: NSPoint(x: x, y: y))
            } else {
                path.line(to: NSPoint(x: x, y: y))
                fillPath.line(to: NSPoint(x: x, y: y))
            }
        }

        fillPath.line(to: NSPoint(x: bounds.width - padding, y: padding))
        fillPath.close()

        // Draw fill with transparency
        lineColor.withAlphaComponent(0.15).setFill()
        fillPath.fill()

        // Draw line
        lineColor.setStroke()
        path.lineWidth = 1.5
        path.stroke()

        drawBorder()
    }

    private func drawEmptyState(in rect: NSRect) {
        let dashPath = NSBezierPath()
        dashPath.move(to: NSPoint(x: 2, y: rect.height / 2))
        dashPath.line(to: NSPoint(x: rect.width - 2, y: rect.height / 2))

        RetroTheme.secondaryText.setStroke()
        dashPath.lineWidth = 1
        dashPath.setLineDash([4, 4], count: 2, phase: 0)
        dashPath.stroke()
    }

    private func drawBorder() {
        RetroTheme.separator.setStroke()
        let borderPath = NSBezierPath(rect: bounds.insetBy(dx: 0.5, dy: 0.5))
        borderPath.lineWidth = 1
        borderPath.stroke()
    }
}
