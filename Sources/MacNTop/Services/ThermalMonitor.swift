import Foundation
import IOKit

// MARK: - ThermalMonitor

/// Monitor for system thermal state and temperatures.
public actor ThermalMonitor {
    // MARK: - Properties

    private var smcConnection: io_connect_t = 0
    private var isSetup = false

    // MARK: - Initialization

    public init() {}

    deinit {
        if smcConnection != 0 {
            IOServiceClose(smcConnection)
        }
    }

    // MARK: - Setup

    private func setupSMCConnectionIfNeeded() {
        guard !isSetup else { return }
        isSetup = true

        let matchingDict = IOServiceMatching("AppleSMC")
        let service = IOServiceGetMatchingService(kIOMainPortDefault, matchingDict)
        guard service != 0 else { return }
        defer { IOObjectRelease(service) }

        IOServiceOpen(service, mach_task_self_, 0, &smcConnection)
    }

    // MARK: - Public Methods

    /// Collects current thermal metrics.
    public func collectMetrics() async -> ThermalMetrics {
        setupSMCConnectionIfNeeded()

        let state = ThermalState(from: ProcessInfo.processInfo.thermalState)
        let cpuTemp = readTemperature(key: "TC0P") ?? readTemperature(key: "Tp09")
        let gpuTemp = readTemperature(key: "TG0P") ?? readTemperature(key: "Tg05")
        let socTemp = readTemperature(key: "Ts0P") ?? readTemperature(key: "Tp01")
        let fanSpeed = readFanSpeed()

        return ThermalMetrics(
            state: state,
            cpuTemperature: cpuTemp,
            gpuTemperature: gpuTemp,
            socTemperature: socTemp,
            fanSpeedRPM: fanSpeed,
            timestamp: Date()
        )
    }

    // MARK: - Private Methods

    private func readTemperature(key: String) -> Double? {
        guard smcConnection != 0 else { return nil }

        // SMC key reading requires specific IOKit calls
        // This is a simplified version - full implementation needs SMC protocol
        return readSMCValue(key: key)
    }

    private func readFanSpeed() -> Int? {
        guard smcConnection != 0 else { return nil }

        // Fan speed keys: F0Ac (actual), F0Mn (min), F0Mx (max)
        if let speed = readSMCValue(key: "F0Ac") {
            return Int(speed)
        }
        return nil
    }

    private func readSMCValue(key: String) -> Double? {
        // SMC reading is complex and requires proper struct definitions
        // For now, try to read via IOKit registry
        return readIOKitSensorValue(containing: key)
    }

    private func readIOKitSensorValue(containing name: String) -> Double? {
        let matchingDict = IOServiceMatching("IOHIDSensor")
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

            var props: Unmanaged<CFMutableDictionary>?
            guard IORegistryEntryCreateCFProperties(entry, &props, kCFAllocatorDefault, 0) == KERN_SUCCESS,
                  let properties = props?.takeRetainedValue() as? [String: Any] else {
                continue
            }

            if let sensorName = properties["Product"] as? String,
               sensorName.localizedCaseInsensitiveContains(name),
               let currentValue = properties["CurrentValue"] as? Double {
                return currentValue
            }
        }

        return nil
    }
}
