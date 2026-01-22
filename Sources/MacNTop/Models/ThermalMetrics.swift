import Foundation

// MARK: - Thermal State

/// System thermal state classification.
public enum ThermalState: String, Sendable, CaseIterable {
    case nominal = "Nominal"
    case fair = "Fair"
    case serious = "Serious"
    case critical = "Critical"

    /// Color indicator for the thermal state.
    public var isWarning: Bool {
        self == .serious || self == .critical
    }

    /// Creates from ProcessInfo thermal state.
    public init(from processInfoState: ProcessInfo.ThermalState) {
        switch processInfoState {
        case .nominal: self = .nominal
        case .fair: self = .fair
        case .serious: self = .serious
        case .critical: self = .critical
        @unknown default: self = .nominal
        }
    }
}

// MARK: - Thermal Metrics

/// System thermal information.
public struct ThermalMetrics: Sendable {
    /// Current thermal state of the system.
    public let state: ThermalState

    /// CPU temperature in Celsius (if available).
    public let cpuTemperature: Double?

    /// GPU temperature in Celsius (if available).
    public let gpuTemperature: Double?

    /// SoC (System on Chip) temperature in Celsius (if available).
    public let socTemperature: Double?

    /// Fan speed in RPM (if available, for Macs with fans).
    public let fanSpeedRPM: Int?

    /// Timestamp when these metrics were collected.
    public let timestamp: Date
}

extension ThermalMetrics {
    /// Human-readable CPU temperature string.
    public var formattedCPUTemp: String? {
        cpuTemperature.map { String(format: "%.0f°C", $0) }
    }

    /// Human-readable GPU temperature string.
    public var formattedGPUTemp: String? {
        gpuTemperature.map { String(format: "%.0f°C", $0) }
    }

    /// Human-readable SoC temperature string.
    public var formattedSoCTemp: String? {
        socTemperature.map { String(format: "%.0f°C", $0) }
    }

    /// Human-readable fan speed string.
    public var formattedFanSpeed: String? {
        fanSpeedRPM.map { "\($0) RPM" }
    }

    /// Default metrics with just thermal state.
    public static func basic(state: ThermalState) -> ThermalMetrics {
        ThermalMetrics(
            state: state,
            cpuTemperature: nil,
            gpuTemperature: nil,
            socTemperature: nil,
            fanSpeedRPM: nil,
            timestamp: Date()
        )
    }
}
