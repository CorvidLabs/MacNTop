import AppKit

/// View displaying memory usage with segmented bar and legend.
public final class MemoryView: NSView {
    // MARK: - Subviews

    private let titleLabel: NSTextField = {
        let label = NSTextField(labelWithString: "├─ Memory ")
        label.font = RetroTheme.largeMono
        label.textColor = RetroTheme.accent
        label.shadow = RetroTheme.glowShadow(color: RetroTheme.accent)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let usageLabel: NSTextField = {
        let label = NSTextField(labelWithString: "")
        label.font = RetroTheme.largeMono
        label.textColor = RetroTheme.primaryText
        label.alignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let segmentedBar: SegmentedMemoryBar = {
        let bar = SegmentedMemoryBar()
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()

    private let legendStack: NSStackView = {
        let stack = NSStackView()
        stack.orientation = .horizontal
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let sparkline: SparklineView = {
        let view = SparklineView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Initialization

    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupViews()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    // MARK: - Setup

    private func setupViews() {
        wantsLayer = true
        layer?.backgroundColor = RetroTheme.background.cgColor

        addSubview(titleLabel)
        addSubview(usageLabel)
        addSubview(segmentedBar)
        addSubview(legendStack)
        addSubview(sparkline)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),

            usageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            usageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            usageLabel.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: 8),

            segmentedBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            segmentedBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            segmentedBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            segmentedBar.heightAnchor.constraint(equalToConstant: 16),

            legendStack.topAnchor.constraint(equalTo: segmentedBar.bottomAnchor, constant: 10),
            legendStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            legendStack.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -20),

            sparkline.topAnchor.constraint(equalTo: legendStack.bottomAnchor, constant: 12),
            sparkline.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            sparkline.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            sparkline.heightAnchor.constraint(equalToConstant: 40),
            sparkline.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])

        setupLegend()
    }

    private func setupLegend() {
        let items: [(String, NSColor, String)] = [
            ("■", NSColor.systemRed, "Wired"),
            ("■", NSColor.systemOrange, "Active"),
            ("■", NSColor.systemYellow, "Comp"),
            ("■", NSColor.systemGreen, "Free")
        ]

        for (dot, color, label) in items {
            let item = NSStackView()
            item.orientation = .horizontal
            item.spacing = 4

            let dotLabel = NSTextField(labelWithString: dot)
            dotLabel.font = RetroTheme.regularMono
            dotLabel.textColor = color

            let textLabel = NSTextField(labelWithString: label)
            textLabel.font = RetroTheme.regularMono
            textLabel.textColor = RetroTheme.secondaryText

            item.addArrangedSubview(dotLabel)
            item.addArrangedSubview(textLabel)
            legendStack.addArrangedSubview(item)
        }
    }

    // MARK: - Configuration

    /// Updates the view with memory metrics.
    public func configure(with metrics: MemoryMetrics, history: [Double]) {
        usageLabel.stringValue = "\(metrics.formattedUsed) / \(metrics.formattedTotal) ─┐"

        let color = RetroTheme.colorForUsage(metrics.pressure)
        usageLabel.textColor = color

        segmentedBar.update(
            wired: Double(metrics.wired) / Double(metrics.total),
            active: Double(metrics.active) / Double(metrics.total),
            compressed: Double(metrics.compressed) / Double(metrics.total),
            cached: Double(metrics.cached) / Double(metrics.total),
            free: Double(metrics.free) / Double(metrics.total)
        )

        sparkline.setValues(history, color: color)
    }
}

// MARK: - SegmentedMemoryBar

private final class SegmentedMemoryBar: NSView {
    private var segments: [(Double, NSColor)] = []

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        wantsLayer = true
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func update(wired: Double, active: Double, compressed: Double, cached: Double, free: Double) {
        segments = [
            (wired, NSColor.systemRed),
            (active, NSColor.systemOrange),
            (compressed, NSColor.systemYellow),
            (cached, NSColor.systemBlue.withAlphaComponent(0.5)),
            (free, NSColor.systemGreen)
        ]
        needsDisplay = true
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        RetroTheme.barBackground.setFill()
        NSBezierPath(rect: bounds).fill()

        var x: CGFloat = 0
        for (ratio, color) in segments {
            let width = bounds.width * CGFloat(ratio)
            if width > 0 {
                let rect = NSRect(x: x, y: 0, width: width, height: bounds.height)
                color.setFill()
                NSBezierPath(rect: rect).fill()
                x += width
            }
        }

        // Draw pixel border
        RetroTheme.separator.setStroke()
        let borderPath = NSBezierPath(rect: bounds.insetBy(dx: 0.5, dy: 0.5))
        borderPath.lineWidth = 1
        borderPath.stroke()
    }
}
