import AppKit

/// Main dashboard view with retro terminal styling and CRT effects.
public final class DashboardView: NSView {
    // MARK: - Subviews

    private let scrollView: NSScrollView = {
        let scroll = NSScrollView()
        scroll.hasVerticalScroller = true
        scroll.hasHorizontalScroller = false
        scroll.autohidesScrollers = true
        scroll.borderType = .noBorder
        scroll.drawsBackground = false
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()

    private let contentView: NSView = {
        let view = NSView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let stackView: NSStackView = {
        let stack = NSStackView()
        stack.orientation = .vertical
        stack.spacing = 0
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let crtOverlay: CRTEffectView = {
        let view = CRTEffectView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.scanlineIntensity = 0.06
        view.vignetteIntensity = 0.25
        return view
    }()

    public let staticInfoView = StaticInfoView()
    public let cpuView = CPUView()
    public let memoryView = MemoryView()
    public let networkView = NetworkView()
    public let diskView = DiskView()
    public let processListView = ProcessListView()

    // MARK: - Initialization

    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupViews()
        observeThemeChanges()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        observeThemeChanges()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func observeThemeChanges() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(themeDidChange),
            name: .themeChanged,
            object: nil
        )
    }

    @objc
    private func themeDidChange() {
        // Refresh the entire view hierarchy
        Task { @MainActor in
            self.window?.contentView?.needsDisplay = true
            self.window?.contentView?.subviews.forEach { $0.needsDisplay = true }

            // Close and reopen the popover to fully refresh
            if let popover = self.window?.parent?.contentViewController?.view.window {
                popover.contentView?.needsDisplay = true
            }

            // Force refresh of this view
            self.layer?.backgroundColor = RetroTheme.background.cgColor
            self.needsDisplay = true
            self.needsLayout = true

            // Recursively update all subviews
            self.refreshSubviews(self)
        }
    }

    private func refreshSubviews(_ view: NSView) {
        view.needsDisplay = true
        if view.wantsLayer {
            view.layer?.backgroundColor = RetroTheme.background.cgColor
        }
        for subview in view.subviews {
            refreshSubviews(subview)
        }
    }

    // MARK: - Setup

    private func setupViews() {
        wantsLayer = true
        layer?.backgroundColor = RetroTheme.background.cgColor

        addSubview(scrollView)
        scrollView.documentView = contentView
        contentView.addSubview(stackView)

        // Add CRT overlay on top
        addSubview(crtOverlay)

        let sections: [NSView] = [
            staticInfoView,
            createSeparator(),
            cpuView,
            createSeparator(),
            memoryView,
            createSeparator(),
            networkView,
            createSeparator(),
            diskView,
            createSeparator(),
            processListView
        ]

        for section in sections {
            section.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview(section)
            section.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        }

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.contentView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: contentView.widthAnchor),

            // CRT overlay covers entire view
            crtOverlay.topAnchor.constraint(equalTo: topAnchor),
            crtOverlay.leadingAnchor.constraint(equalTo: leadingAnchor),
            crtOverlay.trailingAnchor.constraint(equalTo: trailingAnchor),
            crtOverlay.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func createSeparator() -> NSView {
        let container = NSView()
        container.wantsLayer = true
        container.layer?.backgroundColor = RetroTheme.background.cgColor

        let line = NSView()
        line.wantsLayer = true
        line.layer?.backgroundColor = RetroTheme.separator.cgColor
        line.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(line)

        NSLayoutConstraint.activate([
            container.heightAnchor.constraint(equalToConstant: 8),
            line.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            line.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),
            line.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20),
            line.heightAnchor.constraint(equalToConstant: 1)
        ])

        return container
    }
}
