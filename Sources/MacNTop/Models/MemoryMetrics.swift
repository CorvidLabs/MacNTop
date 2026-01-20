import Foundation

/// Memory usage breakdown.
public struct MemoryMetrics: Sendable {
    /// Total physical memory in bytes.
    public let total: UInt64

    /// Active memory in bytes (recently used).
    public let active: UInt64

    /// Wired memory in bytes (cannot be paged out).
    public let wired: UInt64

    /// Compressed memory in bytes.
    public let compressed: UInt64

    /// Inactive memory in bytes (not recently used).
    public let inactive: UInt64

    /// Free memory in bytes.
    public let free: UInt64

    /// Memory used by apps (speculative).
    public let appMemory: UInt64

    /// Timestamp when these metrics were collected.
    public let timestamp: Date

    /// Used memory (active + wired + compressed).
    public var used: UInt64 {
        active + wired + compressed
    }

    /// Available memory (total - used).
    public var available: UInt64 {
        total > used ? total - used : 0
    }

    /// Cached memory (inactive).
    public var cached: UInt64 {
        inactive
    }

    /// Memory pressure as a percentage (0-100).
    public var pressure: Double {
        guard total > 0 else { return 0 }
        return Double(used) / Double(total) * 100
    }
}

extension MemoryMetrics {
    /// Human-readable used memory string.
    public var formattedUsed: String {
        ByteFormatter.format(bytes: used)
    }

    /// Human-readable available memory string.
    public var formattedAvailable: String {
        ByteFormatter.format(bytes: available)
    }

    /// Human-readable active memory string.
    public var formattedActive: String {
        ByteFormatter.format(bytes: active)
    }

    /// Human-readable wired memory string.
    public var formattedWired: String {
        ByteFormatter.format(bytes: wired)
    }

    /// Human-readable compressed memory string.
    public var formattedCompressed: String {
        ByteFormatter.format(bytes: compressed)
    }

    /// Human-readable total memory string.
    public var formattedTotal: String {
        ByteFormatter.format(bytes: total)
    }
}
