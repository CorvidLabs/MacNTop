import Foundation

/// Orchestrates all metric monitors and provides aggregated data.
public actor MetricsCoordinator {
    // MARK: - Properties

    private let systemInfoService: SystemInfoService
    private let cpuMonitor: CPUMonitor
    private let memoryMonitor: MemoryMonitor
    private let networkMonitor: NetworkMonitor
    private let diskMonitor: DiskMonitor
    private let processMonitor: ProcessMonitor

    private var cpuHistory: HistoricalData<Double>
    private var memoryHistory: HistoricalData<Double>
    private var downloadHistory: HistoricalData<Double>
    private var uploadHistory: HistoricalData<Double>

    private var cachedSystemInfo: SystemInfo?

    private var updateTask: Task<Void, Never>?
    private var isRunning = false

    /// Callback for metrics updates.
    public var onMetricsUpdate: (@Sendable (MetricsSnapshot) async -> Void)?

    // MARK: - Initialization

    public init(historyCapacity: Int = 60) {
        self.systemInfoService = SystemInfoService()
        self.cpuMonitor = CPUMonitor()
        self.memoryMonitor = MemoryMonitor()
        self.networkMonitor = NetworkMonitor()
        self.diskMonitor = DiskMonitor()
        self.processMonitor = ProcessMonitor()

        self.cpuHistory = HistoricalData(capacity: historyCapacity)
        self.memoryHistory = HistoricalData(capacity: historyCapacity)
        self.downloadHistory = HistoricalData(capacity: historyCapacity)
        self.uploadHistory = HistoricalData(capacity: historyCapacity)
    }

    // MARK: - Public Methods

    /// Starts collecting metrics at the specified interval.
    public func start(interval: TimeInterval = 1.0) {
        guard !isRunning else { return }
        isRunning = true

        updateTask = Task { [weak self] in
            while !Task.isCancelled {
                await self?.collectAndNotify()
                try? await Task.sleep(nanoseconds: UInt64(interval * 1_000_000_000))
            }
        }
    }

    /// Stops collecting metrics.
    public func stop() {
        isRunning = false
        updateTask?.cancel()
        updateTask = nil
    }

    /// Collects metrics once and returns a snapshot.
    public func collectOnce() async -> MetricsSnapshot {
        await collectAllMetrics()
    }

    /// Returns the cached system info or fetches it if not available.
    public func getSystemInfo() async -> SystemInfo {
        if let cached = cachedSystemInfo {
            return cached
        }
        let info = await systemInfoService.collectSystemInfo()
        cachedSystemInfo = info
        return info
    }

    /// Returns the current CPU usage history.
    public func getCPUHistory() -> [Double] {
        cpuHistory.values
    }

    /// Returns the current memory usage history.
    public func getMemoryHistory() -> [Double] {
        memoryHistory.values
    }

    /// Returns the current download speed history.
    public func getDownloadHistory() -> [Double] {
        downloadHistory.values
    }

    /// Returns the current upload speed history.
    public func getUploadHistory() -> [Double] {
        uploadHistory.values
    }

    // MARK: - Private Methods

    private func collectAndNotify() async {
        let snapshot = await collectAllMetrics()
        await onMetricsUpdate?(snapshot)
    }

    private func collectAllMetrics() async -> MetricsSnapshot {
        async let cpu = cpuMonitor.collectMetrics()
        async let memory = memoryMonitor.collectMetrics()
        async let network = networkMonitor.collectMetrics()
        async let disk = diskMonitor.collectMetrics()
        async let processes = processMonitor.collectMetrics()

        let (cpuMetrics, memoryMetrics, networkMetrics, diskMetrics, processMetrics) = await (
            cpu, memory, network, disk, processes
        )

        cpuHistory.add(cpuMetrics.averageUsage)
        memoryHistory.add(memoryMetrics.pressure)
        downloadHistory.add(networkMetrics.downloadSpeed)
        uploadHistory.add(networkMetrics.uploadSpeed)

        return MetricsSnapshot(
            cpu: cpuMetrics,
            memory: memoryMetrics,
            network: networkMetrics,
            disk: diskMetrics,
            processes: processMetrics,
            cpuHistory: cpuHistory.values,
            memoryHistory: memoryHistory.values,
            downloadHistory: downloadHistory.values,
            uploadHistory: uploadHistory.values,
            timestamp: Date()
        )
    }
}

/// A snapshot of all current metrics.
public struct MetricsSnapshot: Sendable {
    public let cpu: CPUMetrics
    public let memory: MemoryMetrics
    public let network: NetworkMetrics
    public let disk: DiskMetrics
    public let processes: ProcessMetrics
    public let cpuHistory: [Double]
    public let memoryHistory: [Double]
    public let downloadHistory: [Double]
    public let uploadHistory: [Double]
    public let timestamp: Date
}
