import Foundation

/// Information about a running process.
public struct ProcessItem: Sendable, Identifiable {
    /// Process ID.
    public let pid: pid_t

    /// Process name.
    public let name: String

    /// CPU usage percentage (0-100+, can exceed 100% on multi-core).
    public let cpuUsage: Double

    /// Memory usage in bytes.
    public let memoryUsage: UInt64

    /// Number of threads.
    public let threadCount: Int32

    /// User who owns the process.
    public let user: String

    /// Unique identifier.
    public var id: pid_t { pid }
}

extension ProcessItem {
    /// Human-readable CPU usage string.
    public var formattedCPU: String {
        ByteFormatter.formatPercent(cpuUsage)
    }

    /// Human-readable memory usage string.
    public var formattedMemory: String {
        ByteFormatter.format(bytes: memoryUsage)
    }
}

/// Collection of process metrics.
public struct ProcessMetrics: Sendable {
    /// Top processes sorted by CPU usage.
    public let topByCPU: [ProcessItem]

    /// Top processes sorted by memory usage.
    public let topByMemory: [ProcessItem]

    /// Total number of running processes.
    public let totalProcessCount: Int

    /// Timestamp when these metrics were collected.
    public let timestamp: Date
}
