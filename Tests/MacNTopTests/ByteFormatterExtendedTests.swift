import Foundation
import Testing
@testable import MacNTop

// MARK: - ByteFormatter Extended Tests

@Suite("ByteFormatter Extended")
struct ByteFormatterExtendedTests {
    // MARK: - format(bytes: Int64) Overload

    @Test("Format Int64 positive value")
    func formatInt64Positive() {
        #expect(ByteFormatter.format(bytes: Int64(1024)) == "1.0 KB")
    }

    @Test("Format Int64 zero")
    func formatInt64Zero() {
        #expect(ByteFormatter.format(bytes: Int64(0)) == "0 B")
    }

    @Test("Format Int64 negative value clamps to zero")
    func formatInt64Negative() {
        #expect(ByteFormatter.format(bytes: Int64(-100)) == "0 B")
    }

    @Test("Format Int64 large value")
    func formatInt64Large() {
        #expect(ByteFormatter.format(bytes: Int64(1_073_741_824)) == "1.0 GB")
    }

    // MARK: - Very Large Values

    @Test("Format terabyte value")
    func formatTerabytes() {
        let tb: UInt64 = 1_099_511_627_776  // 1 TB
        #expect(ByteFormatter.format(bytes: tb) == "1.0 TB")
    }

    @Test("Format petabyte value")
    func formatPetabytes() {
        let pb: UInt64 = 1_125_899_906_842_624  // 1 PB
        #expect(ByteFormatter.format(bytes: pb) == "1.0 PB")
    }

    @Test("Format multiple terabytes")
    func formatMultipleTerabytes() {
        let value: UInt64 = 5_497_558_138_880  // 5 TB
        #expect(ByteFormatter.format(bytes: value) == "5.0 TB")
    }

    @Test("Format value between TB and PB")
    func formatBetweenTBAndPB() {
        let value: UInt64 = 549_755_813_888_000  // ~500 TB
        #expect(ByteFormatter.format(bytes: value) == "500.0 TB")
    }

    // MARK: - Rate Formatting Various Magnitudes

    @Test("Format rate zero")
    func formatRateZero() {
        #expect(ByteFormatter.formatRate(bytesPerSecond: 0) == "0 B/s")
    }

    @Test("Format rate bytes range")
    func formatRateBytes() {
        #expect(ByteFormatter.formatRate(bytesPerSecond: 500) == "500 B/s")
    }

    @Test("Format rate kilobytes range")
    func formatRateKilobytes() {
        #expect(ByteFormatter.formatRate(bytesPerSecond: 51200) == "50.0 KB/s")
    }

    @Test("Format rate megabytes range")
    func formatRateMegabytes() {
        #expect(ByteFormatter.formatRate(bytesPerSecond: 52_428_800) == "50.0 MB/s")
    }

    @Test("Format rate gigabytes range")
    func formatRateGigabytes() {
        #expect(ByteFormatter.formatRate(bytesPerSecond: 1_073_741_824) == "1.0 GB/s")
    }

    @Test("Format rate stays at GB/s for very large values")
    func formatRateMaxUnit() {
        // 10 GB/s - should stay in GB/s since that's the max unit for rates
        let tenGB = 10.0 * 1024 * 1024 * 1024
        #expect(ByteFormatter.formatRate(bytesPerSecond: tenGB) == "10.0 GB/s")
    }

    // MARK: - Uptime Edge Cases

    @Test("Format uptime zero seconds")
    func formatUptimeZero() {
        #expect(ByteFormatter.formatUptime(seconds: 0) == "0m")
    }

    @Test("Format uptime exactly one hour")
    func formatUptimeOneHour() {
        #expect(ByteFormatter.formatUptime(seconds: 3600) == "1h")
    }

    @Test("Format uptime exactly one day")
    func formatUptimeOneDay() {
        #expect(ByteFormatter.formatUptime(seconds: 86400) == "1d")
    }

    @Test("Format uptime seconds less than a minute")
    func formatUptimeLessThanMinute() {
        #expect(ByteFormatter.formatUptime(seconds: 30) == "0m")
    }

    @Test("Format uptime exactly one minute")
    func formatUptimeOneMinute() {
        #expect(ByteFormatter.formatUptime(seconds: 60) == "1m")
    }

    @Test("Format uptime hours and minutes")
    func formatUptimeHoursMinutes() {
        // 2 hours 30 minutes
        #expect(ByteFormatter.formatUptime(seconds: 9000) == "2h 30m")
    }

    @Test("Format uptime days and hours")
    func formatUptimeDaysHours() {
        // 3 days 12 hours
        let seconds: TimeInterval = 3 * 86400 + 12 * 3600
        #expect(ByteFormatter.formatUptime(seconds: seconds) == "3d 12h")
    }

    @Test("Format uptime days hours and minutes")
    func formatUptimeDaysHoursMinutes() {
        // 1 day 1 hour 1 minute 1 second
        #expect(ByteFormatter.formatUptime(seconds: 90061) == "1d 1h 1m")
    }

    @Test("Format uptime large number of days")
    func formatUptimeManyDays() {
        // 365 days
        let seconds: TimeInterval = 365 * 86400
        #expect(ByteFormatter.formatUptime(seconds: seconds) == "365d")
    }

    // MARK: - Percent Formatting Edge Cases

    @Test("Format percent with many decimal places truncates to one")
    func formatPercentTruncates() {
        #expect(ByteFormatter.formatPercent(99.999) == "100.0%")
    }

    @Test("Format percent negative value")
    func formatPercentNegative() {
        #expect(ByteFormatter.formatPercent(-1.5) == "-1.5%")
    }

    @Test("Format percent very small value")
    func formatPercentVerySmall() {
        #expect(ByteFormatter.formatPercent(0.1) == "0.1%")
    }

    // MARK: - Boundary Values

    @Test("Format exactly 1024 bytes shows KB")
    func formatExactly1024() {
        #expect(ByteFormatter.format(bytes: UInt64(1024)) == "1.0 KB")
    }

    @Test("Format 1023 bytes shows bytes")
    func formatJustUnder1024() {
        #expect(ByteFormatter.format(bytes: UInt64(1023)) == "1023 B")
    }

    @Test("Format 1 byte")
    func formatOneByte() {
        #expect(ByteFormatter.format(bytes: UInt64(1)) == "1 B")
    }
}
