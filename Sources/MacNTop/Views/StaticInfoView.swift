import AppKit

/// View displaying static system information (FastFetch-style).
public final class StaticInfoView: NSView {
    // MARK: - Subviews

    private let stackView: NSStackView = {
        let stack = NSStackView()
        stack.orientation = .vertical
        stack.spacing = 4
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let hostnameLabel = NSTextField(labelWithString: "")
    private let osLabel = NSTextField(labelWithString: "")
    private let kernelLabel = NSTextField(labelWithString: "")
    private let uptimeLabel = NSTextField(labelWithString: "")
    private let cpuLabel = NSTextField(labelWithString: "")
    private let memoryLabel = NSTextField(labelWithString: "")
    private let gpuLabel = NSTextField(labelWithString: "")
    private let ipLabel = NSTextField(labelWithString: "")

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

        let labels = [hostnameLabel, osLabel, kernelLabel, uptimeLabel, cpuLabel, memoryLabel, gpuLabel, ipLabel]

        for label in labels {
            label.font = RetroTheme.regularMono
            label.textColor = RetroTheme.primaryText
            label.lineBreakMode = .byTruncatingTail
            stackView.addArrangedSubview(label)
        }

        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }

    // MARK: - Configuration

    /// Updates the view with system information.
    public func configure(with info: SystemInfo) {
        hostnameLabel.stringValue = "\(info.username)@\(info.hostname)"
        hostnameLabel.textColor = RetroTheme.accent
        RetroTheme.applyGlow(to: hostnameLabel, color: RetroTheme.accent)

        osLabel.stringValue = "OS: \(info.osName)"
        kernelLabel.stringValue = "Kernel: Darwin \(info.kernelVersion)"
        uptimeLabel.stringValue = "Uptime: \(info.formattedUptime)"
        cpuLabel.stringValue = "CPU: \(info.cpuModel)"
        memoryLabel.stringValue = "Memory: \(info.formattedMemory)"

        if let gpuMem = info.formattedGPUMemory {
            gpuLabel.stringValue = "GPU: \(info.gpuModel) (\(gpuMem))"
        } else {
            gpuLabel.stringValue = "GPU: \(info.gpuModel)"
        }

        ipLabel.stringValue = "IP: \(info.localIP)"
    }

    /// Updates just the uptime value.
    public func updateUptime(_ uptime: String) {
        uptimeLabel.stringValue = "Uptime: \(uptime)"
    }
}
