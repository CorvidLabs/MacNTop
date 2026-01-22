import Foundation

// MARK: - Power Metrics

/// System power consumption metrics for Apple Silicon.
public struct PowerMetrics: Sendable {
    /// Total system power in watts (if available).
    public let systemPower: Double?

    /// CPU package power in watts (if available).
    public let cpuPower: Double?

    /// GPU power in watts (if available).
    public let gpuPower: Double?

    /// ANE (Apple Neural Engine) power in watts (if available).
    public let anePower: Double?

    /// DRAM power in watts (if available).
    public let dramPower: Double?

    /// Whether the system is plugged in.
    public let isPluggedIn: Bool

    /// Battery level percentage (0-100, nil if no battery).
    public let batteryLevel: Double?

    /// Whether the battery is charging.
    public let isCharging: Bool

    /// Timestamp when these metrics were collected.
    public let timestamp: Date
}

extension PowerMetrics {
    /// Human-readable system power string.
    public var formattedSystemPower: String? {
        systemPower.map { String(format: "%.1f W", $0) }
    }

    /// Human-readable CPU power string.
    public var formattedCPUPower: String? {
        cpuPower.map { String(format: "%.1f W", $0) }
    }

    /// Human-readable GPU power string.
    public var formattedGPUPower: String? {
        gpuPower.map { String(format: "%.1f W", $0) }
    }

    /// Human-readable battery level string.
    public var formattedBatteryLevel: String? {
        batteryLevel.map { String(format: "%.0f%%", $0) }
    }

    /// Combined power draw from all components.
    public var totalComponentPower: Double? {
        let components = [cpuPower, gpuPower, anePower, dramPower].compactMap { $0 }
        guard !components.isEmpty else { return nil }
        return components.reduce(0, +)
    }

    /// Unavailable power metrics.
    public static let unavailable = PowerMetrics(
        systemPower: nil,
        cpuPower: nil,
        gpuPower: nil,
        anePower: nil,
        dramPower: nil,
        isPluggedIn: true,
        batteryLevel: nil,
        isCharging: false,
        timestamp: Date()
    )
}
