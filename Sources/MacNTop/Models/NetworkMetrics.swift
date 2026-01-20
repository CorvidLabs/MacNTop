import Foundation

/// Network interface statistics.
public struct NetworkInterfaceMetrics: Sendable, Identifiable {
    /// Interface name (e.g., "en0").
    public let name: String

    /// Human-readable display name.
    public let displayName: String

    /// Whether this is the primary interface.
    public let isPrimary: Bool

    /// Total bytes received.
    public let bytesReceived: UInt64

    /// Total bytes sent.
    public let bytesSent: UInt64

    /// Total packets received.
    public let packetsReceived: UInt64

    /// Total packets sent.
    public let packetsSent: UInt64

    /// Receive errors.
    public let errorsIn: UInt64

    /// Transmit errors.
    public let errorsOut: UInt64

    /// Unique identifier.
    public var id: String { name }
}

/// Aggregate network metrics with speed calculations.
public struct NetworkMetrics: Sendable {
    /// Per-interface metrics.
    public let interfaces: [NetworkInterfaceMetrics]

    /// Download speed in bytes per second.
    public let downloadSpeed: Double

    /// Upload speed in bytes per second.
    public let uploadSpeed: Double

    /// Total bytes downloaded across all interfaces.
    public let totalDownloaded: UInt64

    /// Total bytes uploaded across all interfaces.
    public let totalUploaded: UInt64

    /// Timestamp when these metrics were collected.
    public let timestamp: Date
}

extension NetworkMetrics {
    /// Human-readable download speed string.
    public var formattedDownloadSpeed: String {
        ByteFormatter.formatRate(bytesPerSecond: downloadSpeed)
    }

    /// Human-readable upload speed string.
    public var formattedUploadSpeed: String {
        ByteFormatter.formatRate(bytesPerSecond: uploadSpeed)
    }

    /// Human-readable total downloaded string.
    public var formattedTotalDownloaded: String {
        ByteFormatter.format(bytes: totalDownloaded)
    }

    /// Human-readable total uploaded string.
    public var formattedTotalUploaded: String {
        ByteFormatter.format(bytes: totalUploaded)
    }
}
