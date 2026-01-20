import AppKit

/// A standalone window for displaying the dashboard.
@MainActor
public final class DashboardWindow: NSWindow {
    // MARK: - Properties

    private let dashboardViewController: DashboardViewController

    // MARK: - Initialization

    public init() {
        self.dashboardViewController = DashboardViewController()

        let contentRect = NSRect(x: 0, y: 0, width: 480, height: 720)
        super.init(
            contentRect: contentRect,
            styleMask: [.titled, .closable, .miniaturizable, .resizable],
            backing: .buffered,
            defer: false
        )

        setupWindow()
    }

    // MARK: - Setup

    private func setupWindow() {
        title = "MacNTop"
        contentViewController = dashboardViewController
        minSize = NSSize(width: 400, height: 600)
        maxSize = NSSize(width: 600, height: 900)

        // Set appearance
        backgroundColor = RetroTheme.background
        isOpaque = false
        hasShadow = true

        // Float above other windows but not annoyingly so
        level = .floating
        collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]

        // Position near top-right of screen
        if let screen = NSScreen.main {
            let screenFrame = screen.visibleFrame
            let windowFrame = frame
            let x = screenFrame.maxX - windowFrame.width - 20
            let y = screenFrame.maxY - windowFrame.height - 20
            setFrameOrigin(NSPoint(x: x, y: y))
        }

        // Observe theme changes
        NotificationCenter.default.addObserver(
            forName: .themeChanged,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            Task { @MainActor in
                self?.updateAppearance()
            }
        }
    }

    private func updateAppearance() {
        backgroundColor = RetroTheme.background
    }

    // MARK: - Public Methods

    /// Updates the dashboard with new metrics.
    public func updateMetrics(snapshot: MetricsSnapshot, systemInfo: SystemInfo) {
        dashboardViewController.updateMetrics(snapshot: snapshot, systemInfo: systemInfo)
    }

    /// Shows the window and brings it to front.
    public func showWindow() {
        makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    // MARK: - NSWindow Overrides

    public override var canBecomeKey: Bool {
        true
    }

    public override var canBecomeMain: Bool {
        true
    }

    public override func close() {
        // Post notification so StatusBarController knows window closed
        NotificationCenter.default.post(name: .dashboardWindowClosed, object: self)
        super.close()
    }
}

// MARK: - Notification Extension

extension Notification.Name {
    static let dashboardWindowClosed = Notification.Name("DashboardWindowClosed")
}
