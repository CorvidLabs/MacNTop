import Foundation

/// Monitor for CPU usage metrics using host_processor_info.
public actor CPUMonitor {
    // MARK: - Properties

    private var previousTicks: [CPURawTicks] = []

    // MARK: - Public Methods

    /// Collects current CPU metrics for all cores.
    public func collectMetrics() async -> CPUMetrics {
        let currentTicks = getRawTicks()
        defer { previousTicks = currentTicks }

        let cores: [CPUCoreMetrics]

        if previousTicks.isEmpty || previousTicks.count != currentTicks.count {
            cores = currentTicks.enumerated().map { index, _ in
                CPUCoreMetrics(id: index, user: 0, system: 0, idle: 100, nice: 0)
            }
        } else {
            cores = zip(currentTicks, previousTicks).enumerated().map { index, pair in
                let (current, previous) = pair
                return calculateUsage(current: current, previous: previous, coreIndex: index)
            }
        }

        return CPUMetrics(cores: cores, timestamp: Date())
    }

    // MARK: - Private Methods

    private func getRawTicks() -> [CPURawTicks] {
        var processorCount: natural_t = 0
        var processorInfo: processor_info_array_t?
        var processorInfoCount: mach_msg_type_number_t = 0

        let result = host_processor_info(
            mach_host_self(),
            PROCESSOR_CPU_LOAD_INFO,
            &processorCount,
            &processorInfo,
            &processorInfoCount
        )

        guard result == KERN_SUCCESS, let info = processorInfo else {
            return []
        }

        defer {
            let size = vm_size_t(processorInfoCount) * vm_size_t(MemoryLayout<Int32>.size)
            vm_deallocate(mach_task_self_, vm_address_t(bitPattern: info), size)
        }

        var ticks: [CPURawTicks] = []
        ticks.reserveCapacity(Int(processorCount))

        for i in 0..<Int(processorCount) {
            let offset = Int(CPU_STATE_MAX) * i
            let user = UInt64(info[offset + Int(CPU_STATE_USER)])
            let system = UInt64(info[offset + Int(CPU_STATE_SYSTEM)])
            let idle = UInt64(info[offset + Int(CPU_STATE_IDLE)])
            let nice = UInt64(info[offset + Int(CPU_STATE_NICE)])

            ticks.append(CPURawTicks(user: user, system: system, idle: idle, nice: nice))
        }

        return ticks
    }

    private func calculateUsage(current: CPURawTicks, previous: CPURawTicks, coreIndex: Int) -> CPUCoreMetrics {
        let userDelta = current.user - previous.user
        let systemDelta = current.system - previous.system
        let idleDelta = current.idle - previous.idle
        let niceDelta = current.nice - previous.nice

        let totalDelta = userDelta + systemDelta + idleDelta + niceDelta

        guard totalDelta > 0 else {
            return CPUCoreMetrics(id: coreIndex, user: 0, system: 0, idle: 100, nice: 0)
        }

        let userPercent = Double(userDelta) / Double(totalDelta) * 100
        let systemPercent = Double(systemDelta) / Double(totalDelta) * 100
        let idlePercent = Double(idleDelta) / Double(totalDelta) * 100
        let nicePercent = Double(niceDelta) / Double(totalDelta) * 100

        return CPUCoreMetrics(
            id: coreIndex,
            user: userPercent,
            system: systemPercent,
            idle: idlePercent,
            nice: nicePercent
        )
    }
}
