import Foundation
import IOKit
import IOKit.ps

// MARK: - PowerMonitor

/// Monitor for system power consumption and battery status.
public actor PowerMonitor {
    // MARK: - Initialization

    public init() {}

    // MARK: - Public Methods

    /// Collects current power metrics.
    public func collectMetrics() async -> PowerMetrics {
        let batteryInfo = readBatteryInfo()
        let powerInfo = readPowerConsumption()

        return PowerMetrics(
            systemPower: powerInfo.system,
            cpuPower: powerInfo.cpu,
            gpuPower: powerInfo.gpu,
            anePower: powerInfo.ane,
            dramPower: powerInfo.dram,
            isPluggedIn: batteryInfo.isPluggedIn,
            batteryLevel: batteryInfo.level,
            isCharging: batteryInfo.isCharging,
            timestamp: Date()
        )
    }

    // MARK: - Private Methods

    private func readBatteryInfo() -> (isPluggedIn: Bool, level: Double?, isCharging: Bool) {
        guard let snapshot = IOPSCopyPowerSourcesInfo()?.takeRetainedValue(),
              let sources = IOPSCopyPowerSourcesList(snapshot)?.takeRetainedValue() as? [CFTypeRef],
              let source = sources.first,
              let description = IOPSGetPowerSourceDescription(snapshot, source)?.takeUnretainedValue() as? [String: Any] else {
            return (true, nil, false)
        }

        let isPluggedIn = (description[kIOPSPowerSourceStateKey] as? String) == kIOPSACPowerValue
        let isCharging = (description[kIOPSIsChargingKey] as? Bool) ?? false
        let level = description[kIOPSCurrentCapacityKey] as? Double

        return (isPluggedIn, level, isCharging)
    }

    private func readPowerConsumption() -> (system: Double?, cpu: Double?, gpu: Double?, ane: Double?, dram: Double?) {
        // Power consumption on Apple Silicon is available via IOReport framework
        // or by reading from specific IOKit entries
        let cpuPower = readIOKitPowerValue(named: "CPU")
        let gpuPower = readIOKitPowerValue(named: "GPU")
        let anePower = readIOKitPowerValue(named: "ANE")
        let dramPower = readIOKitPowerValue(named: "DRAM")

        var systemPower: Double?
        if let cpu = cpuPower, let gpu = gpuPower {
            systemPower = cpu + gpu + (anePower ?? 0) + (dramPower ?? 0)
        }

        return (systemPower, cpuPower, gpuPower, anePower, dramPower)
    }

    private func readIOKitPowerValue(named component: String) -> Double? {
        // Try to read power metrics from IOReport or IOKit registry
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

            var props: Unmanaged<CFMutableDictionary>?
            guard IORegistryEntryCreateCFProperties(entry, &props, kCFAllocatorDefault, 0) == KERN_SUCCESS,
                  let properties = props?.takeRetainedValue() as? [String: Any] else {
                continue
            }

            // Look for power-related properties
            if let name = properties["name"] as? String,
               name.localizedCaseInsensitiveContains(component),
               let power = properties["power"] as? Double {
                return power
            }
        }

        return nil
    }
}
