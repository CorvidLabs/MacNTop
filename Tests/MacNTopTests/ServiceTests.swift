import Foundation
import Testing
@testable import MacNTop

// MARK: - NetworkMetrics Tests

@Suite("NetworkMetrics")
struct NetworkMetricsTests {
    @Test("Formatted download speed uses ByteFormatter rate")
    func formattedDownloadSpeed() {
        let metrics = NetworkMetrics(
            interfaces: [],
            downloadSpeed: 1_048_576,
            uploadSpeed: 0,
            totalDownloaded: 0,
            totalUploaded: 0,
            timestamp: Date()
        )
        #expect(metrics.formattedDownloadSpeed == "1.0 MB/s")
    }

    @Test("Formatted upload speed uses ByteFormatter rate")
    func formattedUploadSpeed() {
        let metrics = NetworkMetrics(
            interfaces: [],
            downloadSpeed: 0,
            uploadSpeed: 512,
            totalDownloaded: 0,
            totalUploaded: 0,
            timestamp: Date()
        )
        #expect(metrics.formattedUploadSpeed == "512 B/s")
    }

    @Test("Formatted total downloaded uses ByteFormatter bytes")
    func formattedTotalDownloaded() {
        let metrics = NetworkMetrics(
            interfaces: [],
            downloadSpeed: 0,
            uploadSpeed: 0,
            totalDownloaded: 1_073_741_824,
            totalUploaded: 0,
            timestamp: Date()
        )
        #expect(metrics.formattedTotalDownloaded == "1.0 GB")
    }

    @Test("Formatted total uploaded uses ByteFormatter bytes")
    func formattedTotalUploaded() {
        let metrics = NetworkMetrics(
            interfaces: [],
            downloadSpeed: 0,
            uploadSpeed: 0,
            totalDownloaded: 0,
            totalUploaded: 2_097_152,
            timestamp: Date()
        )
        #expect(metrics.formattedTotalUploaded == "2.0 MB")
    }

    @Test("Zero speeds format correctly")
    func zeroSpeeds() {
        let metrics = NetworkMetrics(
            interfaces: [],
            downloadSpeed: 0,
            uploadSpeed: 0,
            totalDownloaded: 0,
            totalUploaded: 0,
            timestamp: Date()
        )
        #expect(metrics.formattedDownloadSpeed == "0 B/s")
        #expect(metrics.formattedUploadSpeed == "0 B/s")
        #expect(metrics.formattedTotalDownloaded == "0 B")
        #expect(metrics.formattedTotalUploaded == "0 B")
    }
}

// MARK: - DiskVolumeMetrics Tests

@Suite("DiskVolumeMetrics")
struct DiskVolumeMetricsTests {
    @Test("Usage percent with zero total space returns 0")
    func usagePercentZeroTotal() {
        let volume = DiskVolumeMetrics(
            mountPoint: "/",
            name: "Test",
            fileSystem: "apfs",
            totalSpace: 0,
            usedSpace: 0,
            availableSpace: 0
        )
        #expect(volume.usagePercent == 0)
    }

    @Test("Usage percent when half full")
    func usagePercentHalfFull() {
        let volume = DiskVolumeMetrics(
            mountPoint: "/",
            name: "Test",
            fileSystem: "apfs",
            totalSpace: 1000,
            usedSpace: 500,
            availableSpace: 500
        )
        #expect(volume.usagePercent == 50.0)
    }

    @Test("Usage percent when completely full")
    func usagePercentFull() {
        let volume = DiskVolumeMetrics(
            mountPoint: "/",
            name: "Test",
            fileSystem: "apfs",
            totalSpace: 1000,
            usedSpace: 1000,
            availableSpace: 0
        )
        #expect(volume.usagePercent == 100.0)
    }

    @Test("Formatted total space")
    func formattedTotal() {
        let volume = DiskVolumeMetrics(
            mountPoint: "/",
            name: "Macintosh HD",
            fileSystem: "apfs",
            totalSpace: 1_073_741_824,
            usedSpace: 536_870_912,
            availableSpace: 536_870_912
        )
        #expect(volume.formattedTotal == "1.0 GB")
    }

    @Test("Formatted used space")
    func formattedUsed() {
        let volume = DiskVolumeMetrics(
            mountPoint: "/",
            name: "Macintosh HD",
            fileSystem: "apfs",
            totalSpace: 1_073_741_824,
            usedSpace: 536_870_912,
            availableSpace: 536_870_912
        )
        #expect(volume.formattedUsed == "512.0 MB")
    }

    @Test("Formatted available space")
    func formattedAvailable() {
        let volume = DiskVolumeMetrics(
            mountPoint: "/",
            name: "Macintosh HD",
            fileSystem: "apfs",
            totalSpace: 1_073_741_824,
            usedSpace: 536_870_912,
            availableSpace: 536_870_912
        )
        #expect(volume.formattedAvailable == "512.0 MB")
    }
}

// MARK: - DiskIOMetrics Tests

@Suite("DiskIOMetrics")
struct DiskIOMetricsTests {
    @Test("Formatted read speed")
    func formattedReadSpeed() {
        let io = DiskIOMetrics(
            readBytesPerSecond: 10_485_760,
            writeBytesPerSecond: 0,
            totalBytesRead: 0,
            totalBytesWritten: 0,
            timestamp: Date()
        )
        #expect(io.formattedReadSpeed == "10.0 MB/s")
    }

    @Test("Formatted write speed")
    func formattedWriteSpeed() {
        let io = DiskIOMetrics(
            readBytesPerSecond: 0,
            writeBytesPerSecond: 2048,
            totalBytesRead: 0,
            totalBytesWritten: 0,
            timestamp: Date()
        )
        #expect(io.formattedWriteSpeed == "2.0 KB/s")
    }

    @Test("Zero IO formats correctly")
    func zeroIO() {
        let io = DiskIOMetrics(
            readBytesPerSecond: 0,
            writeBytesPerSecond: 0,
            totalBytesRead: 0,
            totalBytesWritten: 0,
            timestamp: Date()
        )
        #expect(io.formattedReadSpeed == "0 B/s")
        #expect(io.formattedWriteSpeed == "0 B/s")
    }
}

// MARK: - GPUMetrics Tests

@Suite("GPUMetrics")
struct GPUMetricsTests {
    @Test("Formatted utilization")
    func formattedUtilization() {
        let gpu = GPUMetrics(
            utilization: 75.3,
            frequencyMHz: nil,
            powerWatts: nil,
            temperatureCelsius: nil,
            timestamp: Date(),
            isAvailable: true
        )
        #expect(gpu.formattedUtilization == "75.3%")
    }

    @Test("Formatted frequency when present")
    func formattedFrequencyPresent() {
        let gpu = GPUMetrics(
            utilization: 50,
            frequencyMHz: 1398,
            powerWatts: nil,
            temperatureCelsius: nil,
            timestamp: Date(),
            isAvailable: true
        )
        #expect(gpu.formattedFrequency == "1398 MHz")
    }

    @Test("Formatted frequency when nil")
    func formattedFrequencyNil() {
        let gpu = GPUMetrics(
            utilization: 50,
            frequencyMHz: nil,
            powerWatts: nil,
            temperatureCelsius: nil,
            timestamp: Date(),
            isAvailable: true
        )
        #expect(gpu.formattedFrequency == nil)
    }

    @Test("Formatted power when present")
    func formattedPowerPresent() {
        let gpu = GPUMetrics(
            utilization: 50,
            frequencyMHz: nil,
            powerWatts: 12.5,
            temperatureCelsius: nil,
            timestamp: Date(),
            isAvailable: true
        )
        #expect(gpu.formattedPower == "12.5 W")
    }

    @Test("Formatted power when nil")
    func formattedPowerNil() {
        let gpu = GPUMetrics(
            utilization: 50,
            frequencyMHz: nil,
            powerWatts: nil,
            temperatureCelsius: nil,
            timestamp: Date(),
            isAvailable: true
        )
        #expect(gpu.formattedPower == nil)
    }

    @Test("Formatted temperature when present")
    func formattedTemperaturePresent() {
        let gpu = GPUMetrics(
            utilization: 50,
            frequencyMHz: nil,
            powerWatts: nil,
            temperatureCelsius: 65.7,
            timestamp: Date(),
            isAvailable: true
        )
        #expect(gpu.formattedTemperature == "66°C")
    }

    @Test("Formatted temperature when nil")
    func formattedTemperatureNil() {
        let gpu = GPUMetrics(
            utilization: 50,
            frequencyMHz: nil,
            powerWatts: nil,
            temperatureCelsius: nil,
            timestamp: Date(),
            isAvailable: true
        )
        #expect(gpu.formattedTemperature == nil)
    }

    @Test("Unavailable static factory")
    func unavailableFactory() {
        let gpu = GPUMetrics.unavailable
        #expect(gpu.utilization == 0)
        #expect(gpu.frequencyMHz == nil)
        #expect(gpu.powerWatts == nil)
        #expect(gpu.temperatureCelsius == nil)
        #expect(gpu.isAvailable == false)
    }
}

// MARK: - ThermalState Tests

@Suite("ThermalState")
struct ThermalStateTests {
    @Test("Nominal is not warning")
    func nominalNotWarning() {
        #expect(ThermalState.nominal.isWarning == false)
    }

    @Test("Fair is not warning")
    func fairNotWarning() {
        #expect(ThermalState.fair.isWarning == false)
    }

    @Test("Serious is warning")
    func seriousIsWarning() {
        #expect(ThermalState.serious.isWarning == true)
    }

    @Test("Critical is warning")
    func criticalIsWarning() {
        #expect(ThermalState.critical.isWarning == true)
    }

    @Test("Init from ProcessInfo nominal")
    func initFromNominal() {
        let state = ThermalState(from: .nominal)
        #expect(state == .nominal)
    }

    @Test("Init from ProcessInfo fair")
    func initFromFair() {
        let state = ThermalState(from: .fair)
        #expect(state == .fair)
    }

    @Test("Init from ProcessInfo serious")
    func initFromSerious() {
        let state = ThermalState(from: .serious)
        #expect(state == .serious)
    }

    @Test("Init from ProcessInfo critical")
    func initFromCritical() {
        let state = ThermalState(from: .critical)
        #expect(state == .critical)
    }

    @Test("Raw values match display strings")
    func rawValues() {
        #expect(ThermalState.nominal.rawValue == "Nominal")
        #expect(ThermalState.fair.rawValue == "Fair")
        #expect(ThermalState.serious.rawValue == "Serious")
        #expect(ThermalState.critical.rawValue == "Critical")
    }
}

// MARK: - ThermalMetrics Tests

@Suite("ThermalMetrics")
struct ThermalMetricsTests {
    @Test("Formatted CPU temperature when present")
    func formattedCPUTempPresent() {
        let metrics = ThermalMetrics(
            state: .nominal,
            cpuTemperature: 42.8,
            gpuTemperature: nil,
            socTemperature: nil,
            fanSpeedRPM: nil,
            timestamp: Date()
        )
        #expect(metrics.formattedCPUTemp == "43°C")
    }

    @Test("Formatted CPU temperature when nil")
    func formattedCPUTempNil() {
        let metrics = ThermalMetrics(
            state: .nominal,
            cpuTemperature: nil,
            gpuTemperature: nil,
            socTemperature: nil,
            fanSpeedRPM: nil,
            timestamp: Date()
        )
        #expect(metrics.formattedCPUTemp == nil)
    }

    @Test("Formatted GPU temperature when present")
    func formattedGPUTempPresent() {
        let metrics = ThermalMetrics(
            state: .nominal,
            cpuTemperature: nil,
            gpuTemperature: 55.0,
            socTemperature: nil,
            fanSpeedRPM: nil,
            timestamp: Date()
        )
        #expect(metrics.formattedGPUTemp == "55°C")
    }

    @Test("Formatted GPU temperature when nil")
    func formattedGPUTempNil() {
        let metrics = ThermalMetrics(
            state: .nominal,
            cpuTemperature: nil,
            gpuTemperature: nil,
            socTemperature: nil,
            fanSpeedRPM: nil,
            timestamp: Date()
        )
        #expect(metrics.formattedGPUTemp == nil)
    }

    @Test("Formatted SoC temperature when present")
    func formattedSoCTempPresent() {
        let metrics = ThermalMetrics(
            state: .nominal,
            cpuTemperature: nil,
            gpuTemperature: nil,
            socTemperature: 38.2,
            fanSpeedRPM: nil,
            timestamp: Date()
        )
        #expect(metrics.formattedSoCTemp == "38°C")
    }

    @Test("Formatted SoC temperature when nil")
    func formattedSoCTempNil() {
        let metrics = ThermalMetrics(
            state: .nominal,
            cpuTemperature: nil,
            gpuTemperature: nil,
            socTemperature: nil,
            fanSpeedRPM: nil,
            timestamp: Date()
        )
        #expect(metrics.formattedSoCTemp == nil)
    }

    @Test("Formatted fan speed when present")
    func formattedFanSpeedPresent() {
        let metrics = ThermalMetrics(
            state: .nominal,
            cpuTemperature: nil,
            gpuTemperature: nil,
            socTemperature: nil,
            fanSpeedRPM: 2500,
            timestamp: Date()
        )
        #expect(metrics.formattedFanSpeed == "2500 RPM")
    }

    @Test("Formatted fan speed when nil")
    func formattedFanSpeedNil() {
        let metrics = ThermalMetrics(
            state: .nominal,
            cpuTemperature: nil,
            gpuTemperature: nil,
            socTemperature: nil,
            fanSpeedRPM: nil,
            timestamp: Date()
        )
        #expect(metrics.formattedFanSpeed == nil)
    }

    @Test("Basic factory creates metrics with nil temperatures")
    func basicFactory() {
        let metrics = ThermalMetrics.basic(state: .serious)
        #expect(metrics.state == .serious)
        #expect(metrics.cpuTemperature == nil)
        #expect(metrics.gpuTemperature == nil)
        #expect(metrics.socTemperature == nil)
        #expect(metrics.fanSpeedRPM == nil)
    }
}

// MARK: - PowerMetrics Tests

@Suite("PowerMetrics")
struct PowerMetricsTests {
    @Test("Formatted system power when present")
    func formattedSystemPowerPresent() {
        let power = PowerMetrics(
            systemPower: 15.3,
            cpuPower: nil,
            gpuPower: nil,
            anePower: nil,
            dramPower: nil,
            isPluggedIn: true,
            batteryLevel: nil,
            isCharging: false,
            timestamp: Date()
        )
        #expect(power.formattedSystemPower == "15.3 W")
    }

    @Test("Formatted system power when nil")
    func formattedSystemPowerNil() {
        let power = PowerMetrics(
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
        #expect(power.formattedSystemPower == nil)
    }

    @Test("Formatted CPU power when present")
    func formattedCPUPowerPresent() {
        let power = PowerMetrics(
            systemPower: nil,
            cpuPower: 8.2,
            gpuPower: nil,
            anePower: nil,
            dramPower: nil,
            isPluggedIn: true,
            batteryLevel: nil,
            isCharging: false,
            timestamp: Date()
        )
        #expect(power.formattedCPUPower == "8.2 W")
    }

    @Test("Formatted GPU power when present")
    func formattedGPUPowerPresent() {
        let power = PowerMetrics(
            systemPower: nil,
            cpuPower: nil,
            gpuPower: 5.7,
            anePower: nil,
            dramPower: nil,
            isPluggedIn: true,
            batteryLevel: nil,
            isCharging: false,
            timestamp: Date()
        )
        #expect(power.formattedGPUPower == "5.7 W")
    }

    @Test("Formatted battery level when present")
    func formattedBatteryLevelPresent() {
        let power = PowerMetrics(
            systemPower: nil,
            cpuPower: nil,
            gpuPower: nil,
            anePower: nil,
            dramPower: nil,
            isPluggedIn: false,
            batteryLevel: 85.0,
            isCharging: false,
            timestamp: Date()
        )
        #expect(power.formattedBatteryLevel == "85%")
    }

    @Test("Formatted battery level when nil")
    func formattedBatteryLevelNil() {
        let power = PowerMetrics(
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
        #expect(power.formattedBatteryLevel == nil)
    }

    @Test("Total component power with all components")
    func totalComponentPowerAll() {
        let power = PowerMetrics(
            systemPower: nil,
            cpuPower: 5.0,
            gpuPower: 3.0,
            anePower: 1.0,
            dramPower: 2.0,
            isPluggedIn: true,
            batteryLevel: nil,
            isCharging: false,
            timestamp: Date()
        )
        #expect(power.totalComponentPower == 11.0)
    }

    @Test("Total component power with some nil components")
    func totalComponentPowerPartial() {
        let power = PowerMetrics(
            systemPower: nil,
            cpuPower: 5.0,
            gpuPower: nil,
            anePower: nil,
            dramPower: 2.0,
            isPluggedIn: true,
            batteryLevel: nil,
            isCharging: false,
            timestamp: Date()
        )
        #expect(power.totalComponentPower == 7.0)
    }

    @Test("Total component power with all nil returns nil")
    func totalComponentPowerAllNil() {
        let power = PowerMetrics(
            systemPower: 20.0,
            cpuPower: nil,
            gpuPower: nil,
            anePower: nil,
            dramPower: nil,
            isPluggedIn: true,
            batteryLevel: nil,
            isCharging: false,
            timestamp: Date()
        )
        #expect(power.totalComponentPower == nil)
    }

    @Test("Total component power with single component")
    func totalComponentPowerSingle() {
        let power = PowerMetrics(
            systemPower: nil,
            cpuPower: 8.5,
            gpuPower: nil,
            anePower: nil,
            dramPower: nil,
            isPluggedIn: true,
            batteryLevel: nil,
            isCharging: false,
            timestamp: Date()
        )
        #expect(power.totalComponentPower == 8.5)
    }

    @Test("Unavailable static factory")
    func unavailableFactory() {
        let power = PowerMetrics.unavailable
        #expect(power.systemPower == nil)
        #expect(power.cpuPower == nil)
        #expect(power.gpuPower == nil)
        #expect(power.anePower == nil)
        #expect(power.dramPower == nil)
        #expect(power.isPluggedIn == true)
        #expect(power.batteryLevel == nil)
        #expect(power.isCharging == false)
        #expect(power.totalComponentPower == nil)
    }
}

// MARK: - ProcessItem Tests

@Suite("ProcessItem")
struct ProcessItemTests {
    @Test("Formatted CPU usage")
    func formattedCPU() {
        let process = ProcessItem(
            pid: 1234,
            name: "TestApp",
            cpuUsage: 45.6,
            memoryUsage: 0,
            threadCount: 10,
            user: "root"
        )
        #expect(process.formattedCPU == "45.6%")
    }

    @Test("Formatted memory usage")
    func formattedMemory() {
        let process = ProcessItem(
            pid: 1234,
            name: "TestApp",
            cpuUsage: 0,
            memoryUsage: 104_857_600,
            threadCount: 10,
            user: "root"
        )
        #expect(process.formattedMemory == "100.0 MB")
    }

    @Test("Formatted CPU with zero usage")
    func formattedCPUZero() {
        let process = ProcessItem(
            pid: 1,
            name: "idle",
            cpuUsage: 0,
            memoryUsage: 0,
            threadCount: 1,
            user: "root"
        )
        #expect(process.formattedCPU == "0.0%")
    }

    @Test("Formatted CPU exceeding 100 percent")
    func formattedCPUOver100() {
        let process = ProcessItem(
            pid: 5678,
            name: "HeavyApp",
            cpuUsage: 250.3,
            memoryUsage: 0,
            threadCount: 20,
            user: "user"
        )
        #expect(process.formattedCPU == "250.3%")
    }

    @Test("Process identity via pid")
    func processIdentity() {
        let process = ProcessItem(
            pid: 42,
            name: "test",
            cpuUsage: 0,
            memoryUsage: 0,
            threadCount: 1,
            user: "user"
        )
        #expect(process.id == 42)
    }
}
