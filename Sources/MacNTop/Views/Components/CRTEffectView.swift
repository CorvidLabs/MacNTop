import AppKit

/// Overlay view that adds CRT monitor effects (scanlines, vignette, curvature).
public final class CRTEffectView: NSView {
    // MARK: - Properties

    /// Intensity of scanlines (0-1).
    public var scanlineIntensity: CGFloat = 0.08

    /// Intensity of vignette darkening (0-1).
    public var vignetteIntensity: CGFloat = 0.3

    /// Whether to show scanlines.
    public var showScanlines: Bool = true

    /// Whether to show vignette.
    public var showVignette: Bool = true

    // MARK: - Initialization

    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupView()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        wantsLayer = true
        layer?.backgroundColor = NSColor.clear.cgColor
    }

    // MARK: - Drawing

    public override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        guard let context = NSGraphicsContext.current?.cgContext else { return }

        if showScanlines {
            drawScanlines(in: context, rect: bounds)
        }

        if showVignette {
            drawVignette(in: context, rect: bounds)
        }
    }

    private func drawScanlines(in context: CGContext, rect: NSRect) {
        let lineSpacing: CGFloat = 2
        let lineHeight: CGFloat = 1

        context.setFillColor(NSColor.black.withAlphaComponent(scanlineIntensity).cgColor)

        var y: CGFloat = 0
        while y < rect.height {
            context.fill(CGRect(x: 0, y: y, width: rect.width, height: lineHeight))
            y += lineSpacing + lineHeight
        }
    }

    private func drawVignette(in context: CGContext, rect: NSRect) {
        let colors = [
            NSColor.clear.cgColor,
            NSColor.black.withAlphaComponent(vignetteIntensity * 0.5).cgColor,
            NSColor.black.withAlphaComponent(vignetteIntensity).cgColor
        ]
        let locations: [CGFloat] = [0.0, 0.7, 1.0]

        guard let gradient = CGGradient(
            colorsSpace: CGColorSpaceCreateDeviceRGB(),
            colors: colors as CFArray,
            locations: locations
        ) else { return }

        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = max(rect.width, rect.height) * 0.7

        context.drawRadialGradient(
            gradient,
            startCenter: center,
            startRadius: 0,
            endCenter: center,
            endRadius: radius,
            options: .drawsAfterEndLocation
        )
    }

    // MARK: - Hit Testing

    public override func hitTest(_ point: NSPoint) -> NSView? {
        // Pass through all mouse events
        return nil
    }
}
