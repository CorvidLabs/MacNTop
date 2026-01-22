import Foundation
import Testing
@testable import MacNTop

// MARK: - ByteFormatter Tests

@Suite("ByteFormatter")
struct ByteFormatterTests {
    @Test("Formats bytes correctly")
    func formatBytes() {
        #expect(ByteFormatter.format(bytes: UInt64(0)) == "0 B")
        #expect(ByteFormatter.format(bytes: UInt64(512)) == "512 B")
        #expect(ByteFormatter.format(bytes: UInt64(1024)) == "1.0 KB")
        #expect(ByteFormatter.format(bytes: UInt64(1536)) == "1.5 KB")
        #expect(ByteFormatter.format(bytes: UInt64(1_048_576)) == "1.0 MB")
        #expect(ByteFormatter.format(bytes: UInt64(1_073_741_824)) == "1.0 GB")
    }

    @Test("Formats rate correctly")
    func formatRate() {
        #expect(ByteFormatter.formatRate(bytesPerSecond: 0) == "0 B/s")
        #expect(ByteFormatter.formatRate(bytesPerSecond: 1024) == "1.0 KB/s")
        #expect(ByteFormatter.formatRate(bytesPerSecond: 1_048_576) == "1.0 MB/s")
    }

    @Test("Formats uptime correctly")
    func formatUptime() {
        #expect(ByteFormatter.formatUptime(seconds: 60) == "1m")
        #expect(ByteFormatter.formatUptime(seconds: 3600) == "1h")
        #expect(ByteFormatter.formatUptime(seconds: 86400) == "1d")
        #expect(ByteFormatter.formatUptime(seconds: 90061) == "1d 1h 1m")
    }

    @Test("Formats percent correctly")
    func formatPercent() {
        #expect(ByteFormatter.formatPercent(0) == "0.0%")
        #expect(ByteFormatter.formatPercent(50.5) == "50.5%")
        #expect(ByteFormatter.formatPercent(100) == "100.0%")
    }
}

// MARK: - HistoricalData Tests

@Suite("HistoricalData")
struct HistoricalDataTests {
    @Test("Maintains capacity limit")
    func capacityLimit() {
        var history = HistoricalData<Int>(capacity: 3)
        history.add(1)
        history.add(2)
        history.add(3)
        history.add(4)

        #expect(history.values.count == 3)
        #expect(history.values == [2, 3, 4])
    }

    @Test("Returns latest value")
    func latestValue() {
        var history = HistoricalData<Int>(capacity: 5)
        history.add(10)
        history.add(20)
        history.add(30)

        #expect(history.latest == 30)
    }

    @Test("Empty history returns nil latest")
    func emptyLatest() {
        let history = HistoricalData<Int>(capacity: 5)
        #expect(history.latest == nil)
    }
}

// MARK: - Theme Tests

@Suite("Themes")
struct ThemeTests {
    @Test("All themes have unique names")
    func uniqueNames() {
        let names = Themes.all.map(\.name)
        let uniqueNames = Set(names)
        #expect(names.count == uniqueNames.count)
    }

    @Test("All themes count")
    func themeCount() {
        #expect(Themes.all.count == 6)
    }

    @Test("Retro Green is default")
    func defaultTheme() {
        #expect(Themes.retroGreen.name == "Retro Green")
    }
}

// MARK: - CPUMetrics Tests

@Suite("CPUMetrics")
struct CPUMetricsTests {
    @Test("Average usage calculation")
    func averageUsage() {
        let cores = [
            CPUCoreMetrics(id: 0, user: 20, system: 10, idle: 70, nice: 0),
            CPUCoreMetrics(id: 1, user: 30, system: 10, idle: 60, nice: 0),
            CPUCoreMetrics(id: 2, user: 40, system: 10, idle: 50, nice: 0)
        ]
        let metrics = CPUMetrics(cores: cores, timestamp: Date())

        // (30 + 40 + 50) / 3 = 40
        #expect(metrics.averageUsage == 40.0)
    }

    @Test("Core total usage")
    func coreTotal() {
        let core = CPUCoreMetrics(id: 0, user: 25, system: 15, idle: 60, nice: 0)
        #expect(core.total == 40.0)
    }
}

// MARK: - MemoryMetrics Tests

@Suite("MemoryMetrics")
struct MemoryMetricsTests {
    @Test("Used memory calculation")
    func usedMemory() {
        let metrics = MemoryMetrics(
            total: 16_000_000_000,
            active: 4_000_000_000,
            wired: 2_000_000_000,
            compressed: 1_000_000_000,
            inactive: 1_000_000_000,
            free: 8_000_000_000,
            appMemory: 4_000_000_000,
            swap: .zero,
            timestamp: Date()
        )

        // used = active + wired + compressed = 7GB
        #expect(metrics.used == 7_000_000_000)
    }

    @Test("Pressure percentage")
    func pressure() {
        let metrics = MemoryMetrics(
            total: 100,
            active: 30,
            wired: 20,
            compressed: 10,
            inactive: 10,
            free: 30,
            appMemory: 30,
            swap: .zero,
            timestamp: Date()
        )

        // pressure = (used / total) * 100 = 60%
        #expect(metrics.pressure == 60.0)
    }
}
