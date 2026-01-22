import Foundation

// MARK: - GPU Metrics

/// GPU usage and performance metrics for Apple Silicon.
public struct GPUMetrics: Sendable {
    /// GPU utilization percentage (0-100).
    public let utilization: Double

    /// Current GPU frequency in MHz (if available).
    public let frequencyMHz: Double?

    /// GPU power consumption in watts (if available).
    public let powerWatts: Double?

    /// GPU temperature in Celsius (if available).
    public let temperatureCelsius: Double?

    /// Timestamp when these metrics were collected.
    public let timestamp: Date

    /// Whether GPU metrics are available on this system.
    public let isAvailable: Bool

    /// Empty/unavailable metrics.
    public static let unavailable = GPUMetrics(
        utilization: 0,
        frequencyMHz: nil,
        powerWatts: nil,
        temperatureCelsius: nil,
        timestamp: Date(),
        isAvailable: false
    )
}

extension GPUMetrics {
    /// Human-readable utilization string.
    public var formattedUtilization: String {
        String(format: "%.1f%%", utilization)
    }

    /// Human-readable frequency string.
    public var formattedFrequency: String? {
        frequencyMHz.map { String(format: "%.0f MHz", $0) }
    }

    /// Human-readable power string.
    public var formattedPower: String? {
        powerWatts.map { String(format: "%.1f W", $0) }
    }

    /// Human-readable temperature string.
    public var formattedTemperature: String? {
        temperatureCelsius.map { String(format: "%.0f°C", $0) }
    }
}
