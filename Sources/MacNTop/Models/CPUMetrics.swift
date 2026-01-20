import Foundation

/// CPU usage metrics for a single core.
public struct CPUCoreMetrics: Sendable, Identifiable {
    /// Core index (0-based).
    public let id: Int

    /// User-mode CPU usage percentage (0-100).
    public let user: Double

    /// System-mode CPU usage percentage (0-100).
    public let system: Double

    /// Idle percentage (0-100).
    public let idle: Double

    /// Nice priority usage percentage (0-100).
    public let nice: Double

    /// Total CPU usage percentage (user + system + nice).
    public var total: Double {
        user + system + nice
    }
}

/// Aggregate CPU metrics for all cores.
public struct CPUMetrics: Sendable {
    /// Per-core metrics.
    public let cores: [CPUCoreMetrics]

    /// Timestamp when these metrics were collected.
    public let timestamp: Date

    /// Average CPU usage across all cores.
    public var averageUsage: Double {
        guard !cores.isEmpty else { return 0 }
        return cores.map(\.total).reduce(0, +) / Double(cores.count)
    }

    /// Average user-mode usage across all cores.
    public var averageUser: Double {
        guard !cores.isEmpty else { return 0 }
        return cores.map(\.user).reduce(0, +) / Double(cores.count)
    }

    /// Average system-mode usage across all cores.
    public var averageSystem: Double {
        guard !cores.isEmpty else { return 0 }
        return cores.map(\.system).reduce(0, +) / Double(cores.count)
    }
}

/// Raw CPU tick counts for delta calculation.
internal struct CPURawTicks: Sendable {
    internal let user: UInt64
    internal let system: UInt64
    internal let idle: UInt64
    internal let nice: UInt64

    internal var total: UInt64 {
        user + system + idle + nice
    }
}
