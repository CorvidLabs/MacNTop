import AppKit

/// View displaying top processes in retro terminal style.
public final class ProcessListView: NSView {
    // MARK: - Subviews

    private let titleLabel: NSTextField = {
        let label = NSTextField(labelWithString: "└─ Processes ")
        label.font = RetroTheme.largeMono
        label.textColor = RetroTheme.accent
        label.shadow = RetroTheme.glowShadow(color: RetroTheme.accent)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let countLabel: NSTextField = {
        let label = NSTextField(labelWithString: "")
        label.font = RetroTheme.regularMono
        label.textColor = RetroTheme.secondaryText
        label.alignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let toggleLabel: NSTextField = {
        let label = NSTextField(labelWithString: "    NAME                            [CPU]   MEM")
        label.font = RetroTheme.regularMono
        label.textColor = RetroTheme.secondaryText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let processStackView: NSStackView = {
        let stack = NSStackView()
        stack.orientation = .vertical
        stack.spacing = 3
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private var processLabels: [NSTextField] = []
    private var currentMetrics: ProcessMetrics?
    private var showingCPU = true

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
        addSubview(countLabel)
        addSubview(toggleLabel)
        addSubview(processStackView)

        let clickGesture = NSClickGestureRecognizer(target: self, action: #selector(toggleMode))
        toggleLabel.addGestureRecognizer(clickGesture)

        for _ in 0..<10 {
            let label = NSTextField(labelWithString: "")
            label.font = RetroTheme.regularMono
            label.textColor = RetroTheme.primaryText
            processStackView.addArrangedSubview(label)
            processLabels.append(label)
        }

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),

            countLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            countLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

            toggleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            toggleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),

            processStackView.topAnchor.constraint(equalTo: toggleLabel.bottomAnchor, constant: 8),
            processStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            processStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            processStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }

    // MARK: - Configuration

    /// Updates the view with process metrics.
    public func configure(with metrics: ProcessMetrics) {
        currentMetrics = metrics
        countLabel.stringValue = "\(metrics.totalProcessCount) running"
        updateProcessList()
    }

    // MARK: - Actions

    @objc
    private func toggleMode() {
        showingCPU.toggle()
        // Update header to show which column is sorted
        toggleLabel.stringValue = showingCPU
            ? "    NAME                            [CPU]   MEM"
            : "    NAME                             CPU   [MEM]"
        updateProcessList()
    }

    // MARK: - Private Methods

    private func updateProcessList() {
        guard let metrics = currentMetrics else { return }

        let processes = showingCPU ? metrics.topByCPU : metrics.topByMemory

        for (index, label) in processLabels.enumerated() {
            if index < processes.count {
                let process = processes[index]
                let name = process.name.prefix(32).padding(toLength: 32, withPad: " ", startingAt: 0)
                let cpu = process.formattedCPU.padding(toLength: 7, withPad: " ", startingAt: 0)
                let mem = process.formattedMemory
                label.stringValue = String(format: "%2d. %@%@%@", index + 1, name, cpu, mem)
                label.textColor = index < 3 ? RetroTheme.warning : RetroTheme.primaryText
            } else {
                label.stringValue = ""
            }
        }
    }
}
