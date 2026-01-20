import AppKit

/// View displaying CPU usage with compact per-core bars and sparkline.
public final class CPUView: NSView {
    // MARK: - Subviews

    private let headerStack: NSStackView = {
        let stack = NSStackView()
        stack.orientation = .horizontal
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let titleLabel: NSTextField = {
        let label = NSTextField(labelWithString: "┌─ CPU ")
        label.font = RetroTheme.largeMono
        label.textColor = RetroTheme.accent
        label.shadow = RetroTheme.glowShadow(color: RetroTheme.accent)
        return label
    }()

    private let averageLabel: NSTextField = {
        let label = NSTextField(labelWithString: "")
        label.font = RetroTheme.largeMono
        label.textColor = RetroTheme.primaryText
        label.alignment = .right
        return label
    }()

    private let sparkline: SparklineView = {
        let view = SparklineView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let coreGridStack: NSStackView = {
        let stack = NSStackView()
        stack.orientation = .vertical
        stack.spacing = 6
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private var coreRows: [[CoreBarView]] = []

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

        headerStack.addArrangedSubview(titleLabel)
        headerStack.addArrangedSubview(averageLabel)

        addSubview(headerStack)
        addSubview(sparkline)
        addSubview(coreGridStack)

        NSLayoutConstraint.activate([
            headerStack.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            headerStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            headerStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

            sparkline.topAnchor.constraint(equalTo: headerStack.bottomAnchor, constant: 12),
            sparkline.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            sparkline.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            sparkline.heightAnchor.constraint(equalToConstant: 50),

            coreGridStack.topAnchor.constraint(equalTo: sparkline.bottomAnchor, constant: 14),
            coreGridStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            coreGridStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            coreGridStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }

    // MARK: - Configuration

    /// Updates the view with CPU metrics.
    public func configure(with metrics: CPUMetrics, history: [Double]) {
        averageLabel.stringValue = String(format: "%.1f%% ─┐", metrics.averageUsage)
        averageLabel.textColor = RetroTheme.colorForUsage(metrics.averageUsage)

        sparkline.setValues(history, color: RetroTheme.primaryText)

        let coreCount = metrics.cores.count
        let columns = 4

        if coreRows.isEmpty || coreRows.flatMap({ $0 }).count != coreCount {
            setupCoreGrid(count: coreCount, columns: columns)
        }

        for (index, core) in metrics.cores.enumerated() {
            let row = index / columns
            let col = index % columns
            guard row < coreRows.count, col < coreRows[row].count else { continue }
            coreRows[row][col].update(usage: core.total, coreIndex: index)
        }
    }

    // MARK: - Private Methods

    private func setupCoreGrid(count: Int, columns: Int) {
        coreGridStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        coreRows.removeAll()

        let rows = (count + columns - 1) / columns

        for row in 0..<rows {
            let rowStack = NSStackView()
            rowStack.orientation = .horizontal
            rowStack.spacing = 16
            rowStack.distribution = .fillEqually

            var rowViews: [CoreBarView] = []

            for col in 0..<columns {
                let index = row * columns + col
                let coreBar = CoreBarView()

                if index < count {
                    coreBar.update(usage: 0, coreIndex: index)
                } else {
                    coreBar.alphaValue = 0
                }

                rowStack.addArrangedSubview(coreBar)
                rowViews.append(coreBar)
            }

            coreRows.append(rowViews)
            coreGridStack.addArrangedSubview(rowStack)
        }
    }
}

// MARK: - CoreBarView

private final class CoreBarView: NSView {
    private let labelField: NSTextField = {
        let label = NSTextField(labelWithString: "C0")
        label.font = RetroTheme.regularMono
        label.textColor = RetroTheme.secondaryText
        label.alignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let percentField: NSTextField = {
        let label = NSTextField(labelWithString: "0%")
        label.font = RetroTheme.regularMono
        label.textColor = RetroTheme.primaryText
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

        addSubview(labelField)
        addSubview(barContainer)
        addSubview(percentField)
        barContainer.addSubview(barFill)

        let widthConstraint = barFill.widthAnchor.constraint(equalToConstant: 0)
        fillWidthConstraint = widthConstraint

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 18),

            labelField.leadingAnchor.constraint(equalTo: leadingAnchor),
            labelField.centerYAnchor.constraint(equalTo: centerYAnchor),
            labelField.widthAnchor.constraint(equalToConstant: 28),

            barContainer.leadingAnchor.constraint(equalTo: labelField.trailingAnchor, constant: 4),
            barContainer.trailingAnchor.constraint(equalTo: percentField.leadingAnchor, constant: -6),
            barContainer.centerYAnchor.constraint(equalTo: centerYAnchor),
            barContainer.heightAnchor.constraint(equalToConstant: 12),

            barFill.leadingAnchor.constraint(equalTo: barContainer.leadingAnchor),
            barFill.topAnchor.constraint(equalTo: barContainer.topAnchor),
            barFill.bottomAnchor.constraint(equalTo: barContainer.bottomAnchor),
            widthConstraint,

            percentField.trailingAnchor.constraint(equalTo: trailingAnchor),
            percentField.centerYAnchor.constraint(equalTo: centerYAnchor),
            percentField.widthAnchor.constraint(equalToConstant: 40)
        ])
    }

    func update(usage: Double, coreIndex: Int) {
        labelField.stringValue = String(format: "C%d", coreIndex)
        percentField.stringValue = String(format: "%.0f%%", usage)

        let color = RetroTheme.colorForUsage(usage)
        percentField.textColor = color
        barFill.layer?.backgroundColor = color.cgColor

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let barWidth = self.barContainer.bounds.width
            let fillWidth = barWidth * CGFloat(usage / 100.0)
            self.fillWidthConstraint?.constant = max(0, fillWidth)
        }
    }
}
