import Foundation

/// Static system information that doesn't change during runtime.
public struct SystemInfo: Sendable {
    /// The computer's hostname.
    public let hostname: String

    /// The macOS version string (e.g., "14.2.1").
    public let osVersion: String

    /// The full OS name with version (e.g., "macOS Sonoma 14.2.1").
    public let osName: String

    /// System uptime in seconds.
    public let uptime: TimeInterval

    /// CPU model name (e.g., "Apple M1 Pro").
    public let cpuModel: String

    /// Number of physical CPU cores.
    public let cpuCoreCount: Int

    /// Number of logical CPU cores (including hyperthreading).
    public let cpuLogicalCoreCount: Int

    /// Total physical RAM in bytes.
    public let totalMemory: UInt64

    /// GPU model name.
    public let gpuModel: String

    /// GPU VRAM in bytes (if available).
    public let gpuMemory: UInt64?

    /// Primary local IP address.
    public let localIP: String

    /// Kernel version string.
    public let kernelVersion: String

    /// Current username.
    public let username: String
}

extension SystemInfo {
    /// Human-readable total memory string.
    public var formattedMemory: String {
        ByteFormatter.format(bytes: totalMemory)
    }

    /// Human-readable uptime string.
    public var formattedUptime: String {
        ByteFormatter.formatUptime(seconds: uptime)
    }

    /// Human-readable GPU memory string.
    public var formattedGPUMemory: String? {
        gpuMemory.map { ByteFormatter.format(bytes: $0) }
    }
}
