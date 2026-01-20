import Foundation
import Darwin

/// Monitor for process metrics using libproc.
public actor ProcessMonitor {
    // MARK: - Properties

    private let maxProcesses: Int
    private var previousCPUTimes: [pid_t: UInt64] = [:]
    private var previousTimestamp: Date?

    // MARK: - Initialization

    /// Creates a new process monitor.
    /// - Parameter maxProcesses: Maximum number of top processes to return.
    public init(maxProcesses: Int = 10) {
        self.maxProcesses = maxProcesses
    }

    // MARK: - Public Methods

    /// Collects current process metrics.
    public func collectMetrics() async -> ProcessMetrics {
        let now = Date()
        let elapsed = previousTimestamp.map { now.timeIntervalSince($0) } ?? 1.0
        let processes = getAllProcesses(elapsed: elapsed)

        previousTimestamp = now

        let topByCPU = Array(
            processes
                .sorted { $0.cpuUsage > $1.cpuUsage }
                .prefix(maxProcesses)
        )

        let topByMemory = Array(
            processes
                .sorted { $0.memoryUsage > $1.memoryUsage }
                .prefix(maxProcesses)
        )

        return ProcessMetrics(
            topByCPU: topByCPU,
            topByMemory: topByMemory,
            totalProcessCount: processes.count,
            timestamp: now
        )
    }

    // MARK: - Private Methods

    private func getAllProcesses(elapsed: TimeInterval) -> [ProcessItem] {
        var pids = [pid_t](repeating: 0, count: 4096)
        let bufferSize = Int32(pids.count * MemoryLayout<pid_t>.size)

        let bytesReturned = proc_listallpids(&pids, bufferSize)
        guard bytesReturned > 0 else { return [] }

        let count = Int(bytesReturned) / MemoryLayout<pid_t>.size

        var processes: [ProcessItem] = []
        var newCPUTimes: [pid_t: UInt64] = [:]
        processes.reserveCapacity(count)

        for i in 0..<count {
            let pid = pids[i]
            guard pid > 0 else { continue }

            if let (processItem, cpuTime) = getProcessItem(pid: pid, elapsed: elapsed) {
                processes.append(processItem)
                newCPUTimes[pid] = cpuTime
            }
        }

        previousCPUTimes = newCPUTimes
        return processes
    }

    private func getProcessItem(pid: pid_t, elapsed: TimeInterval) -> (ProcessItem, UInt64)? {
        var taskInfo = proc_taskinfo()
        let taskInfoSize = Int32(MemoryLayout<proc_taskinfo>.size)

        let result = proc_pidinfo(
            pid,
            PROC_PIDTASKINFO,
            0,
            &taskInfo,
            taskInfoSize
        )

        guard result == taskInfoSize else { return nil }

        let name = getProcessName(pid: pid)

        // Skip processes with no name or just version-like names
        if name == "Unknown" || name.isEmpty {
            return nil
        }

        let user = getProcessUser(pid: pid)

        // Calculate CPU usage as percentage based on delta
        let currentCPUTime = taskInfo.pti_total_user + taskInfo.pti_total_system
        let previousCPUTime = previousCPUTimes[pid] ?? currentCPUTime
        let cpuDelta = currentCPUTime > previousCPUTime ? currentCPUTime - previousCPUTime : 0

        // Convert nanoseconds to percentage of elapsed time
        // cpuDelta is in nanoseconds, elapsed is in seconds
        let cpuUsage = (Double(cpuDelta) / Double(NSEC_PER_SEC)) / elapsed * 100.0

        let memoryUsage = UInt64(taskInfo.pti_resident_size)
        let threadCount = taskInfo.pti_threadnum

        let item = ProcessItem(
            pid: pid,
            name: name,
            cpuUsage: min(cpuUsage, 100.0 * Double(ProcessInfo.processInfo.processorCount)),
            memoryUsage: memoryUsage,
            threadCount: threadCount,
            user: user
        )

        return (item, currentCPUTime)
    }

    private func getProcessName(pid: pid_t) -> String {
        var buffer = [CChar](repeating: 0, count: Int(MAXPATHLEN))
        let result = proc_name(pid, &buffer, UInt32(buffer.count))

        if result > 0 {
            let name = String(cString: buffer)
            // Filter out empty or very short names
            if name.count > 2 {
                return name
            }
        }

        // Try to get name from BSD info as fallback
        var bsdInfo = proc_bsdinfo()
        let bsdInfoSize = Int32(MemoryLayout<proc_bsdinfo>.size)

        let bsdResult = proc_pidinfo(
            pid,
            PROC_PIDTBSDINFO,
            0,
            &bsdInfo,
            bsdInfoSize
        )

        if bsdResult == bsdInfoSize {
            let nameBuffer = withUnsafePointer(to: bsdInfo.pbi_comm) { ptr in
                ptr.withMemoryRebound(to: CChar.self, capacity: Int(MAXCOMLEN)) { charPtr in
                    String(cString: charPtr)
                }
            }
            if nameBuffer.count > 2 {
                return nameBuffer
            }
        }

        return "Unknown"
    }

    private func getProcessUser(pid: pid_t) -> String {
        var bsdInfo = proc_bsdinfo()
        let bsdInfoSize = Int32(MemoryLayout<proc_bsdinfo>.size)

        let result = proc_pidinfo(
            pid,
            PROC_PIDTBSDINFO,
            0,
            &bsdInfo,
            bsdInfoSize
        )

        guard result == bsdInfoSize else { return "unknown" }

        let uid = bsdInfo.pbi_uid
        if let passwd = getpwuid(uid) {
            return String(cString: passwd.pointee.pw_name)
        }

        return "uid:\(uid)"
    }
}
