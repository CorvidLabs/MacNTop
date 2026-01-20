import AppKit

/// View displaying network speeds with sparklines.
public final class NetworkView: NSView {
    // MARK: - Subviews

    private let titleLabel: NSTextField = {
        let label = NSTextField(labelWithString: "├─ Network ")
        label.font = RetroTheme.largeMono
        label.textColor = RetroTheme.accent
        label.shadow = RetroTheme.glowShadow(color: RetroTheme.accent)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let downloadLabel: NSTextField = {
        let label = NSTextField(labelWithString: "↓ 0 B/s")
        label.font = RetroTheme.regularMono
        label.textColor = RetroTheme.primaryText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let downloadSparkline: SparklineView = {
        let view = SparklineView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let uploadLabel: NSTextField = {
        let label = NSTextField(labelWithString: "↑ 0 B/s")
        label.font = RetroTheme.regularMono
        label.textColor = RetroTheme.warning
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let uploadSparkline: SparklineView = {
        let view = SparklineView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let totalLabel: NSTextField = {
        let label = NSTextField(labelWithString: "")
        label.font = RetroTheme.regularMono
        label.textColor = RetroTheme.secondaryText
        label.translatesAutoresizingMaskIntoConstraints = false
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

        addSubview(titleLabel)
        addSubview(downloadLabel)
        addSubview(downloadSparkline)
        addSubview(uploadLabel)
        addSubview(uploadSparkline)
        addSubview(totalLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),

            downloadLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            downloadLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),

            downloadSparkline.topAnchor.constraint(equalTo: downloadLabel.bottomAnchor, constant: 6),
            downloadSparkline.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            downloadSparkline.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            downloadSparkline.heightAnchor.constraint(equalToConstant: 32),

            uploadLabel.topAnchor.constraint(equalTo: downloadSparkline.bottomAnchor, constant: 10),
            uploadLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),

            uploadSparkline.topAnchor.constraint(equalTo: uploadLabel.bottomAnchor, constant: 6),
            uploadSparkline.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            uploadSparkline.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            uploadSparkline.heightAnchor.constraint(equalToConstant: 32),

            totalLabel.topAnchor.constraint(equalTo: uploadSparkline.bottomAnchor, constant: 10),
            totalLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            totalLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }

    // MARK: - Configuration

    /// Updates the view with network metrics.
    public func configure(with metrics: NetworkMetrics, downloadHistory: [Double], uploadHistory: [Double]) {
        downloadLabel.stringValue = "↓ \(metrics.formattedDownloadSpeed)"
        uploadLabel.stringValue = "↑ \(metrics.formattedUploadSpeed)"

        downloadSparkline.setValues(downloadHistory, color: RetroTheme.primaryText)
        uploadSparkline.setValues(uploadHistory, color: RetroTheme.warning)

        totalLabel.stringValue = "Total: ↓\(metrics.formattedTotalDownloaded)  ↑\(metrics.formattedTotalUploaded)"
    }
}
