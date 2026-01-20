import Foundation

/// Utility for formatting byte values and rates into human-readable strings.
public enum ByteFormatter {
    // MARK: - Byte Size Formatting

    /// Formats a byte count into a human-readable string (e.g., "1.5 GB").
    public static func format(bytes: UInt64) -> String {
        let units = ["B", "KB", "MB", "GB", "TB", "PB"]
        var value = Double(bytes)
        var unitIndex = 0

        while value >= 1024 && unitIndex < units.count - 1 {
            value /= 1024
            unitIndex += 1
        }

        if unitIndex == 0 {
            return String(format: "%.0f %@", value, units[unitIndex])
        } else {
            return String(format: "%.1f %@", value, units[unitIndex])
        }
    }

    /// Formats a byte count into a human-readable string (e.g., "1.5 GB").
    public static func format(bytes: Int64) -> String {
        format(bytes: UInt64(max(0, bytes)))
    }

    // MARK: - Rate Formatting

    /// Formats a byte rate into a human-readable string (e.g., "1.5 MB/s").
    public static func formatRate(bytesPerSecond: Double) -> String {
        let units = ["B/s", "KB/s", "MB/s", "GB/s"]
        var value = bytesPerSecond
        var unitIndex = 0

        while value >= 1024 && unitIndex < units.count - 1 {
            value /= 1024
            unitIndex += 1
        }

        if unitIndex == 0 {
            return String(format: "%.0f %@", value, units[unitIndex])
        } else {
            return String(format: "%.1f %@", value, units[unitIndex])
        }
    }

    // MARK: - Duration Formatting

    /// Formats seconds into a human-readable uptime string (e.g., "2d 5h 30m").
    public static func formatUptime(seconds: TimeInterval) -> String {
        let totalSeconds = Int(seconds)
        let days = totalSeconds / 86400
        let hours = (totalSeconds % 86400) / 3600
        let minutes = (totalSeconds % 3600) / 60

        var components: [String] = []

        if days > 0 {
            components.append("\(days)d")
        }
        if hours > 0 {
            components.append("\(hours)h")
        }
        if minutes > 0 || components.isEmpty {
            components.append("\(minutes)m")
        }

        return components.joined(separator: " ")
    }

    // MARK: - Percentage Formatting

    /// Formats a percentage value (0-100) into a string.
    public static func formatPercent(_ value: Double) -> String {
        String(format: "%.1f%%", value)
    }
}
