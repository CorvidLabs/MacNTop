import Foundation

/// Disk volume usage metrics.
public struct DiskVolumeMetrics: Sendable, Identifiable {
    /// Volume mount point (e.g., "/").
    public let mountPoint: String

    /// Volume name (e.g., "Macintosh HD").
    public let name: String

    /// File system type (e.g., "apfs").
    public let fileSystem: String

    /// Total capacity in bytes.
    public let totalSpace: UInt64

    /// Used space in bytes.
    public let usedSpace: UInt64

    /// Available space in bytes.
    public let availableSpace: UInt64

    /// Unique identifier.
    public var id: String { mountPoint }

    /// Usage percentage (0-100).
    public var usagePercent: Double {
        guard totalSpace > 0 else { return 0 }
        return Double(usedSpace) / Double(totalSpace) * 100
    }
}

extension DiskVolumeMetrics {
    /// Human-readable total space string.
    public var formattedTotal: String {
        ByteFormatter.format(bytes: totalSpace)
    }

    /// Human-readable used space string.
    public var formattedUsed: String {
        ByteFormatter.format(bytes: usedSpace)
    }

    /// Human-readable available space string.
    public var formattedAvailable: String {
        ByteFormatter.format(bytes: availableSpace)
    }
}

/// Disk I/O statistics.
public struct DiskIOMetrics: Sendable {
    /// Bytes read per second.
    public let readBytesPerSecond: Double

    /// Bytes written per second.
    public let writeBytesPerSecond: Double

    /// Total bytes read since boot.
    public let totalBytesRead: UInt64

    /// Total bytes written since boot.
    public let totalBytesWritten: UInt64

    /// Timestamp when these metrics were collected.
    public let timestamp: Date
}

extension DiskIOMetrics {
    /// Human-readable read speed string.
    public var formattedReadSpeed: String {
        ByteFormatter.formatRate(bytesPerSecond: readBytesPerSecond)
    }

    /// Human-readable write speed string.
    public var formattedWriteSpeed: String {
        ByteFormatter.formatRate(bytesPerSecond: writeBytesPerSecond)
    }
}

/// Combined disk metrics.
public struct DiskMetrics: Sendable {
    /// Volume usage metrics.
    public let volumes: [DiskVolumeMetrics]

    /// I/O statistics.
    public let io: DiskIOMetrics

    /// Timestamp when these metrics were collected.
    public let timestamp: Date
}
