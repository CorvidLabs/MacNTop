import Foundation
import Metal

/// Service for collecting static system information.
public actor SystemInfoService {
    // MARK: - Public Methods

    /// Collects all static system information.
    public func collectSystemInfo() async -> SystemInfo {
        async let hostname = getHostname()
        async let osInfo = getOSInfo()
        async let cpuInfo = getCPUInfo()
        async let memoryInfo = getMemoryInfo()
        async let gpuInfo = getGPUInfo()
        async let networkInfo = getLocalIP()
        async let kernelInfo = getKernelVersion()
        async let uptimeValue = getUptime()
        async let usernameValue = getUsername()

        let (host, os, cpu, memory, gpu, network, kernel, uptime, username) = await (
            hostname, osInfo, cpuInfo, memoryInfo, gpuInfo, networkInfo, kernelInfo, uptimeValue, usernameValue
        )

        return SystemInfo(
            hostname: host,
            osVersion: os.version,
            osName: os.name,
            uptime: uptime,
            cpuModel: cpu.model,
            cpuCoreCount: cpu.physicalCores,
            cpuLogicalCoreCount: cpu.logicalCores,
            totalMemory: memory,
            gpuModel: gpu.model,
            gpuMemory: gpu.memory,
            localIP: network,
            kernelVersion: kernel,
            username: username
        )
    }

    // MARK: - Private Methods

    private func getHostname() -> String {
        ProcessInfo.processInfo.hostName
    }

    private func getOSInfo() -> (name: String, version: String) {
        let version = ProcessInfo.processInfo.operatingSystemVersion
        let versionString = "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"

        var osName = "macOS"
        switch version.majorVersion {
        case 15: osName = "macOS Sequoia"
        case 14: osName = "macOS Sonoma"
        case 13: osName = "macOS Ventura"
        case 12: osName = "macOS Monterey"
        case 11: osName = "macOS Big Sur"
        default: osName = "macOS"
        }

        return ("\(osName) \(versionString)", versionString)
    }

    private func getCPUInfo() -> (model: String, physicalCores: Int, logicalCores: Int) {
        let model = sysctlString("machdep.cpu.brand_string") ?? "Unknown CPU"
        let physicalCores = ProcessInfo.processInfo.processorCount
        let logicalCores = ProcessInfo.processInfo.activeProcessorCount

        return (model, physicalCores, logicalCores)
    }

    private func getMemoryInfo() -> UInt64 {
        UInt64(ProcessInfo.processInfo.physicalMemory)
    }

    private func getGPUInfo() -> (model: String, memory: UInt64?) {
        guard let device = MTLCreateSystemDefaultDevice() else {
            return ("Unknown GPU", nil)
        }

        let name = device.name
        let memory: UInt64?

        if device.hasUnifiedMemory {
            memory = nil
        } else {
            memory = UInt64(device.recommendedMaxWorkingSetSize)
        }

        return (name, memory)
    }

    private func getLocalIP() -> String {
        var address = "127.0.0.1"

        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0, let firstAddr = ifaddr else {
            return address
        }
        defer { freeifaddrs(ifaddr) }

        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            let addrFamily = interface.ifa_addr.pointee.sa_family

            guard addrFamily == UInt8(AF_INET) else { continue }

            let name = String(cString: interface.ifa_name)
            guard name == "en0" || name == "en1" else { continue }

            var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
            getnameinfo(
                interface.ifa_addr,
                socklen_t(interface.ifa_addr.pointee.sa_len),
                &hostname,
                socklen_t(hostname.count),
                nil,
                socklen_t(0),
                NI_NUMERICHOST
            )
            address = String(cString: hostname)
            break
        }

        return address
    }

    private func getKernelVersion() -> String {
        sysctlString("kern.osrelease") ?? "Unknown"
    }

    private func getUptime() -> TimeInterval {
        var boottime = timeval()
        var size = MemoryLayout<timeval>.size
        var mib: [Int32] = [CTL_KERN, KERN_BOOTTIME]

        guard sysctl(&mib, 2, &boottime, &size, nil, 0) == 0 else {
            return 0
        }

        let bootDate = Date(timeIntervalSince1970: TimeInterval(boottime.tv_sec))
        return Date().timeIntervalSince(bootDate)
    }

    private func getUsername() -> String {
        NSUserName()
    }

    private func sysctlString(_ name: String) -> String? {
        var size = 0
        sysctlbyname(name, nil, &size, nil, 0)

        guard size > 0 else { return nil }

        var buffer = [CChar](repeating: 0, count: size)
        sysctlbyname(name, &buffer, &size, nil, 0)

        return String(cString: buffer)
    }
}
