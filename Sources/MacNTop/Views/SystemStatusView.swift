import AppKit

/// View displaying GPU, thermal, and power metrics.
public final class SystemStatusView: NSView {
    // MARK: - Subviews

    private let gpuSection: NSStackView = {
        let stack = NSStackView()
        stack.orientation = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let gpuTitleLabel: NSTextField = {
        let label = NSTextField(labelWithString: "├─ GPU ")
        label.font = RetroTheme.largeMono
        label.textColor = RetroTheme.accent
        label.shadow = RetroTheme.glowShadow(color: RetroTheme.accent)
        return label
    }()

    private let gpuUsageLabel: NSTextField = {
        let label = NSTextField(labelWithString: "0%")
        label.font = RetroTheme.largeMono
        label.textColor = RetroTheme.primaryText
        label.alignment = .right
        return label
    }()

    private let gpuBar: UsageBar = {
        let bar = UsageBar()
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()

    private let gpuSparkline: SparklineView = {
        let view = SparklineView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let thermalSection: NSStackView = {
        let stack = NSStackView()
        stack.orientation = .vertical
        stack.spacing = 6
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let thermalTitleLabel: NSTextField = {
        let label = NSTextField(labelWithString: "├─ Thermal ")
        label.font = RetroTheme.largeMono
        label.textColor = RetroTheme.accent
        label.shadow = RetroTheme.glowShadow(color: RetroTheme.accent)
        return label
    }()

    private let thermalStateLabel: NSTextField = {
        let label = NSTextField(labelWithString: "Nominal")
        label.font = RetroTheme.regularMono
        label.textColor = RetroTheme.primaryText
        return label
    }()

    private let temperatureLabel: NSTextField = {
        let label = NSTextField(labelWithString: "")
        label.font = RetroTheme.smallMono
        label.textColor = RetroTheme.secondaryText
        return label
    }()

    private let powerSection: NSStackView = {
        let stack = NSStackView()
        stack.orientation = .vertical
        stack.spacing = 6
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let powerTitleLabel: NSTextField = {
        let label = NSTextField(labelWithString: "├─ Power ")
        label.font = RetroTheme.largeMono
        label.textColor = RetroTheme.accent
        label.shadow = RetroTheme.glowShadow(color: RetroTheme.accent)
        return label
    }()

    private let powerValueLabel: NSTextField = {
        let label = NSTextField(labelWithString: "")
        label.font = RetroTheme.regularMono
        label.textColor = RetroTheme.primaryText
        return label
    }()

    private let batteryLabel: NSTextField = {
        let label = NSTextField(labelWithString: "")
        label.font = RetroTheme.smallMono
        label.textColor = RetroTheme.secondaryText
        return label
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

        // GPU section
        let gpuHeaderStack = NSStackView(views: [gpuTitleLabel, gpuUsageLabel])
        gpuHeaderStack.distribution = .fill

        gpuSection.addArrangedSubview(gpuHeaderStack)
        gpuSection.addArrangedSubview(gpuBar)
        gpuSection.addArrangedSubview(gpuSparkline)

        // Thermal section
        let thermalHeaderStack = NSStackView(views: [thermalTitleLabel, thermalStateLabel])
        thermalHeaderStack.distribution = .fill

        thermalSection.addArrangedSubview(thermalHeaderStack)
        thermalSection.addArrangedSubview(temperatureLabel)

        // Power section
        let powerHeaderStack = NSStackView(views: [powerTitleLabel, powerValueLabel])
        powerHeaderStack.distribution = .fill

        powerSection.addArrangedSubview(powerHeaderStack)
        powerSection.addArrangedSubview(batteryLabel)

        addSubview(gpuSection)
        addSubview(thermalSection)
        addSubview(powerSection)

        NSLayoutConstraint.activate([
            gpuSection.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            gpuSection.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            gpuSection.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

            gpuBar.heightAnchor.constraint(equalToConstant: 12),
            gpuSparkline.heightAnchor.constraint(equalToConstant: 30),

            thermalSection.topAnchor.constraint(equalTo: gpuSection.bottomAnchor, constant: 16),
            thermalSection.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            thermalSection.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

            powerSection.topAnchor.constraint(equalTo: thermalSection.bottomAnchor, constant: 16),
            powerSection.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            powerSection.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            powerSection.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }

    // MARK: - Configuration

    /// Updates the view with GPU, thermal, and power metrics.
    public func configure(
        gpu: GPUMetrics,
        thermal: ThermalMetrics,
        power: PowerMetrics,
        gpuHistory: [Double]
    ) {
        // GPU
        if gpu.isAvailable {
            gpuUsageLabel.stringValue = gpu.formattedUtilization
            let color = RetroTheme.colorForUsage(gpu.utilization)
            gpuUsageLabel.textColor = color
            gpuBar.update(percent: gpu.utilization, color: color)
            gpuSparkline.setValues(gpuHistory, color: color)
            gpuSection.isHidden = false
        } else {
            gpuSection.isHidden = true
        }

        // Thermal
        thermalStateLabel.stringValue = thermal.state.rawValue
        thermalStateLabel.textColor = thermal.state.isWarning ? RetroTheme.warning : RetroTheme.primaryText

        var tempStrings: [String] = []
        if let cpuTemp = thermal.formattedCPUTemp {
            tempStrings.append("CPU: \(cpuTemp)")
        }
        if let gpuTemp = thermal.formattedGPUTemp {
            tempStrings.append("GPU: \(gpuTemp)")
        }
        if let fan = thermal.formattedFanSpeed {
            tempStrings.append("Fan: \(fan)")
        }
        temperatureLabel.stringValue = tempStrings.joined(separator: "  ")
        temperatureLabel.isHidden = tempStrings.isEmpty

        // Power
        if let systemPower = power.formattedSystemPower {
            powerValueLabel.stringValue = systemPower
            powerSection.isHidden = false
        } else if let cpuPower = power.formattedCPUPower {
            powerValueLabel.stringValue = "CPU: \(cpuPower)"
            powerSection.isHidden = false
        } else {
            powerSection.isHidden = true
        }

        // Battery
        if let batteryLevel = power.formattedBatteryLevel {
            let status = power.isCharging ? "⚡" : (power.isPluggedIn ? "🔌" : "🔋")
            batteryLabel.stringValue = "\(status) \(batteryLevel)"
            batteryLabel.isHidden = false
        } else {
            batteryLabel.isHidden = true
        }
    }
}

// MARK: - UsageBar

private final class UsageBar: NSView {
    private var percent: Double = 0
    private var barColor: NSColor = RetroTheme.primaryText

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        wantsLayer = true
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func update(percent: Double, color: NSColor) {
        self.percent = percent
        self.barColor = color
        needsDisplay = true
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        RetroTheme.barBackground.setFill()
        NSBezierPath(rect: bounds).fill()

        let fillWidth = bounds.width * CGFloat(percent / 100.0)
        if fillWidth > 0 {
            barColor.setFill()
            NSBezierPath(rect: NSRect(x: 0, y: 0, width: fillWidth, height: bounds.height)).fill()
        }

        RetroTheme.separator.setStroke()
        let borderPath = NSBezierPath(rect: bounds.insetBy(dx: 0.5, dy: 0.5))
        borderPath.lineWidth = 1
        borderPath.stroke()
    }
}
