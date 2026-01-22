import Foundation
import IOKit

// MARK: - GPUMonitor

/// Monitor for Apple Silicon GPU metrics via IOKit.
public actor GPUMonitor {
    // MARK: - Properties

    private var acceleratorEntry: io_service_t = 0
    private var lastSampleTime: Date?
    private var lastInUseTime: UInt64 = 0
    private var isSetup = false

    // MARK: - Initialization

    public init() {}

    deinit {
        if acceleratorEntry != 0 {
            IOObjectRelease(acceleratorEntry)
        }
    }

    // MARK: - Setup

    private func setupAcceleratorServiceIfNeeded() {
        guard !isSetup else { return }
        isSetup = true
        // Find AGXAccelerator for Apple Silicon GPU metrics
        let matchingDict = IOServiceMatching("AGXAccelerator")
        acceleratorEntry = IOServiceGetMatchingService(kIOMainPortDefault, matchingDict)
    }

    // MARK: - Public Methods

    /// Collects current GPU metrics.
    public func collectMetrics() async -> GPUMetrics {
        setupAcceleratorServiceIfNeeded()

        guard acceleratorEntry != 0 else {
            return .unavailable
        }

        let utilization = readGPUUtilization()
        let frequency = readGPUFrequency()
        let power = readGPUPower()
        let temperature = readGPUTemperature()

        return GPUMetrics(
            utilization: utilization,
            frequencyMHz: frequency,
            powerWatts: power,
            temperatureCelsius: temperature,
            timestamp: Date(),
            isAvailable: true
        )
    }

    // MARK: - Private Methods

    private func readGPUUtilization() -> Double {
        // Try to read GPU utilization from performance statistics
        guard let props = readProperties(from: acceleratorEntry) else {
            return 0
        }

        // Look for utilization in various property keys
        if let perfStats = props["PerformanceStatistics"] as? [String: Any] {
            // Device Utilization % is commonly available
            if let utilization = perfStats["Device Utilization %"] as? Double {
                return utilization
            }
            if let utilization = perfStats["GPU Activity(%)"] as? Double {
                return utilization
            }
            // Calculate from in-use time if available
            if let inUseTime = perfStats["In use system time"] as? UInt64 {
                return calculateUtilizationFromTime(inUseTime)
            }
        }

        return 0
    }

    private func calculateUtilizationFromTime(_ currentInUseTime: UInt64) -> Double {
        let now = Date()
        defer {
            lastSampleTime = now
            lastInUseTime = currentInUseTime
        }

        guard let lastTime = lastSampleTime else {
            return 0
        }

        let elapsedSeconds = now.timeIntervalSince(lastTime)
        guard elapsedSeconds > 0 else { return 0 }

        let deltaInUse = currentInUseTime - lastInUseTime
        let elapsedNanoseconds = UInt64(elapsedSeconds * 1_000_000_000)

        guard elapsedNanoseconds > 0 else { return 0 }

        return min(100, Double(deltaInUse) / Double(elapsedNanoseconds) * 100)
    }

    private func readGPUFrequency() -> Double? {
        guard let props = readProperties(from: acceleratorEntry) else {
            return nil
        }

        if let perfStats = props["PerformanceStatistics"] as? [String: Any] {
            if let freq = perfStats["GPU Core Clock"] as? Double {
                return freq / 1_000_000 // Convert Hz to MHz
            }
            if let freq = perfStats["gpuCoreFrequencyHz"] as? UInt64 {
                return Double(freq) / 1_000_000
            }
        }

        return nil
    }

    private func readGPUPower() -> Double? {
        guard let props = readProperties(from: acceleratorEntry) else {
            return nil
        }

        if let perfStats = props["PerformanceStatistics"] as? [String: Any] {
            if let power = perfStats["GPU Energy"] as? Double {
                // Convert to watts if needed
                return power
            }
        }

        return nil
    }

    private func readGPUTemperature() -> Double? {
        // GPU temperature is typically read from thermal sensors
        // This requires separate IOKit access to AppleSMC or thermal zones
        return readThermalSensorValue(named: "GPU")
    }

    private func readProperties(from entry: io_service_t) -> [String: Any]? {
        var props: Unmanaged<CFMutableDictionary>?
        let result = IORegistryEntryCreateCFProperties(entry, &props, kCFAllocatorDefault, 0)
        guard result == KERN_SUCCESS, let properties = props?.takeRetainedValue() as? [String: Any] else {
            return nil
        }
        return properties
    }

    private func readThermalSensorValue(named name: String) -> Double? {
        // Search for thermal sensor matching the name
        let matchingDict = IOServiceMatching("AppleARMIODevice")
        var iterator: io_iterator_t = 0

        guard IOServiceGetMatchingServices(kIOMainPortDefault, matchingDict, &iterator) == KERN_SUCCESS else {
            return nil
        }
        defer { IOObjectRelease(iterator) }

        var entry = IOIteratorNext(iterator)
        while entry != 0 {
            defer {
                IOObjectRelease(entry)
                entry = IOIteratorNext(iterator)
            }

            if let props = readProperties(from: entry),
               let sensorName = props["name"] as? String,
               sensorName.contains(name),
               let temp = props["temperature"] as? Double {
                return temp
            }
        }

        return nil
    }
}
