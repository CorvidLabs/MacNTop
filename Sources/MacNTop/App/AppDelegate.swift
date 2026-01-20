import AppKit

/// Main application delegate.
@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {
    // MARK: - Properties

    private var statusBarController: StatusBarController?
    private var metricsCoordinator: MetricsCoordinator?
    private var cachedSystemInfo: SystemInfo?

    // MARK: - NSApplicationDelegate

    func applicationDidFinishLaunching(_ notification: Notification) {
        statusBarController = StatusBarController()
        statusBarController?.setup()

        metricsCoordinator = MetricsCoordinator(historyCapacity: 60)
        startMonitoring()
    }

    func applicationWillTerminate(_ notification: Notification) {
        Task {
            await metricsCoordinator?.stop()
        }
        statusBarController?.cleanup()
    }

    // MARK: - Private Methods

    private func startMonitoring() {
        guard let coordinator = metricsCoordinator else { return }

        Task {
            cachedSystemInfo = await coordinator.getSystemInfo()
            await coordinator.start(interval: 1.0)

            await coordinator.setOnMetricsUpdate { [weak self] snapshot in
                guard let self else { return }
                await handleMetricsUpdate(snapshot)
            }
        }
    }

    private func handleMetricsUpdate(_ snapshot: MetricsSnapshot) {
        statusBarController?.updateIcon(
            cpuUsage: snapshot.cpu.averageUsage,
            memoryUsage: snapshot.memory.pressure
        )

        if let systemInfo = cachedSystemInfo {
            statusBarController?.updateDashboard(with: snapshot, systemInfo: systemInfo)
        }
    }
}

// MARK: - MetricsCoordinator Extension

extension MetricsCoordinator {
    func setOnMetricsUpdate(_ handler: @escaping @Sendable (MetricsSnapshot) async -> Void) {
        self.onMetricsUpdate = handler
    }
}

// MARK: - Main Entry Point

@main
struct MacNTopApp {
    static func main() {
        let app = NSApplication.shared
        let delegate = AppDelegate()
        app.delegate = delegate
        app.setActivationPolicy(.accessory)
        app.run()
    }
}
