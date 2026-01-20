import AppKit

/// View displaying disk usage with full-width bars.
public final class DiskView: NSView {
    // MARK: - Subviews

    private let titleLabel: NSTextField = {
        let label = NSTextField(labelWithString: "├─ Disk ")
        label.font = RetroTheme.largeMono
        label.textColor = RetroTheme.accent
        label.shadow = RetroTheme.glowShadow(color: RetroTheme.accent)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let ioLabel: NSTextField = {
        let label = NSTextField(labelWithString: "")
        label.font = RetroTheme.regularMono
        label.textColor = RetroTheme.secondaryText
        label.alignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let volumesStackView: NSStackView = {
        let stack = NSStackView()
        stack.orientation = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private var volumeViews: [DiskVolumeView] = []

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
        addSubview(ioLabel)
        addSubview(volumesStackView)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),

            ioLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            ioLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

            volumesStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            volumesStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            volumesStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            volumesStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }

    // MARK: - Configuration

    /// Updates the view with disk metrics.
    public func configure(with metrics: DiskMetrics) {
        ioLabel.stringValue = "R:\(metrics.io.formattedReadSpeed)  W:\(metrics.io.formattedWriteSpeed)"

        if volumeViews.count != metrics.volumes.count {
            setupVolumeViews(count: metrics.volumes.count)
        }

        for (index, volume) in metrics.volumes.enumerated() {
            guard index < volumeViews.count else { continue }
            volumeViews[index].configure(with: volume)
        }
    }

    // MARK: - Private Methods

    private func setupVolumeViews(count: Int) {
        volumesStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        volumeViews.removeAll()

        for _ in 0..<count {
            let volumeView = DiskVolumeView()
            volumesStackView.addArrangedSubview(volumeView)
            volumeViews.append(volumeView)
        }
    }
}

// MARK: - DiskVolumeView

private final class DiskVolumeView: NSView {
    private let nameLabel: NSTextField = {
        let label = NSTextField(labelWithString: "")
        label.font = RetroTheme.regularMono
        label.textColor = RetroTheme.accent
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let usageLabel: NSTextField = {
        let label = NSTextField(labelWithString: "")
        label.font = RetroTheme.regularMono
        label.textColor = RetroTheme.secondaryText
        label.alignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let barContainer: NSView = {
        let view = NSView()
        view.wantsLayer = true
        view.layer?.backgroundColor = RetroTheme.barBackground.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let barFill: NSView = {
        let view = NSView()
        view.wantsLayer = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var fillWidthConstraint: NSLayoutConstraint?

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false

        addSubview(nameLabel)
        addSubview(usageLabel)
        addSubview(barContainer)
        barContainer.addSubview(barFill)

        let widthConstraint = barFill.widthAnchor.constraint(equalToConstant: 0)
        fillWidthConstraint = widthConstraint

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 36),

            nameLabel.topAnchor.constraint(equalTo: topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),

            usageLabel.topAnchor.constraint(equalTo: topAnchor),
            usageLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            barContainer.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            barContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            barContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            barContainer.heightAnchor.constraint(equalToConstant: 14),

            barFill.leadingAnchor.constraint(equalTo: barContainer.leadingAnchor),
            barFill.topAnchor.constraint(equalTo: barContainer.topAnchor),
            barFill.bottomAnchor.constraint(equalTo: barContainer.bottomAnchor),
            widthConstraint
        ])
    }

    func configure(with volume: DiskVolumeMetrics) {
        nameLabel.stringValue = volume.name
        usageLabel.stringValue = "\(volume.formattedUsed) / \(volume.formattedTotal)"

        let color = colorForUsage(volume.usagePercent)
        usageLabel.textColor = color
        barFill.layer?.backgroundColor = color.cgColor

        // Already on MainActor - update constraint directly
        layoutSubtreeIfNeeded()
        let barWidth = barContainer.bounds.width
        let fillWidth = barWidth * CGFloat(volume.usagePercent / 100.0)
        fillWidthConstraint?.constant = max(0, fillWidth)
    }

    private func colorForUsage(_ percent: Double) -> NSColor {
        switch percent {
        case 0..<60: return RetroTheme.primaryText
        case 60..<80: return RetroTheme.warning
        default: return RetroTheme.critical
        }
    }
}
