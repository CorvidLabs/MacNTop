import Foundation

// MARK: - MemoryMonitor

/// Monitor for memory usage metrics using host_statistics64.
public actor MemoryMonitor {
    // MARK: - Properties

    private let totalMemory: UInt64

    // MARK: - Initialization

    public init() {
        self.totalMemory = UInt64(ProcessInfo.processInfo.physicalMemory)
    }

    // MARK: - Public Methods

    /// Collects current memory metrics.
    public func collectMetrics() async -> MemoryMetrics {
        var stats = vm_statistics64()
        var count = mach_msg_type_number_t(MemoryLayout<vm_statistics64>.size / MemoryLayout<Int32>.size)

        let result = withUnsafeMutablePointer(to: &stats) { statsPtr in
            statsPtr.withMemoryRebound(to: Int32.self, capacity: Int(count)) { ptr in
                host_statistics64(
                    mach_host_self(),
                    HOST_VM_INFO64,
                    ptr,
                    &count
                )
            }
        }

        let swap = collectSwapMetrics()

        guard result == KERN_SUCCESS else {
            return MemoryMetrics(
                total: totalMemory,
                active: 0,
                wired: 0,
                compressed: 0,
                inactive: 0,
                free: totalMemory,
                appMemory: 0,
                swap: swap,
                timestamp: Date()
            )
        }

        // Use getpagesize() which is concurrency-safe
        let pageSize = UInt64(getpagesize())

        let active = UInt64(stats.active_count) * pageSize
        let wired = UInt64(stats.wire_count) * pageSize
        let compressed = UInt64(stats.compressor_page_count) * pageSize
        let inactive = UInt64(stats.inactive_count) * pageSize
        let free = UInt64(stats.free_count) * pageSize
        let speculative = UInt64(stats.speculative_count) * pageSize

        let appMemory = active + speculative

        return MemoryMetrics(
            total: totalMemory,
            active: active,
            wired: wired,
            compressed: compressed,
            inactive: inactive,
            free: free,
            appMemory: appMemory,
            swap: swap,
            timestamp: Date()
        )
    }

    // MARK: - Private Methods

    /// Collects swap usage via sysctl.
    private func collectSwapMetrics() -> SwapMetrics {
        var swapUsage = xsw_usage()
        var size = MemoryLayout<xsw_usage>.size

        let result = sysctlbyname("vm.swapusage", &swapUsage, &size, nil, 0)

        guard result == 0 else {
            return .zero
        }

        return SwapMetrics(
            total: swapUsage.xsu_total,
            used: swapUsage.xsu_used,
            free: swapUsage.xsu_avail
        )
    }
}
