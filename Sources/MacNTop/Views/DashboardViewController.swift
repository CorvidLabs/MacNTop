import AppKit

/// View controller for the dashboard popover content.
public final class DashboardViewController: NSViewController {
    // MARK: - Properties

    private var dashboardView: DashboardView?

    // MARK: - Lifecycle

    public override func loadView() {
        let dashboard = DashboardView()
        dashboard.frame = NSRect(x: 0, y: 0, width: 360, height: 560)
        self.view = dashboard
        self.dashboardView = dashboard
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.wantsLayer = true
        view.layer?.backgroundColor = RetroTheme.background.cgColor
    }

    // MARK: - Public Methods

    /// Updates all views with new metrics.
    public func updateMetrics(snapshot: MetricsSnapshot, systemInfo: SystemInfo) {
        guard let dashboard = dashboardView else { return }

        dashboard.staticInfoView.configure(with: systemInfo)
        dashboard.cpuView.configure(with: snapshot.cpu, history: snapshot.cpuHistory)
        dashboard.systemStatusView.configure(
            gpu: snapshot.gpu,
            thermal: snapshot.thermal,
            power: snapshot.power,
            gpuHistory: snapshot.gpuHistory
        )
        dashboard.memoryView.configure(with: snapshot.memory, history: snapshot.memoryHistory)
        dashboard.networkView.configure(
            with: snapshot.network,
            downloadHistory: snapshot.downloadHistory,
            uploadHistory: snapshot.uploadHistory
        )
        dashboard.diskView.configure(with: snapshot.disk)
        dashboard.processListView.configure(with: snapshot.processes)
    }
}
