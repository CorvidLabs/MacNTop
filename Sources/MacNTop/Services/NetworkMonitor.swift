import Foundation

/// Monitor for network usage metrics using getifaddrs.
public actor NetworkMonitor {
    // MARK: - Properties

    private var previousBytes: (received: UInt64, sent: UInt64) = (0, 0)
    private var previousTimestamp: Date?

    // MARK: - Public Methods

    /// Collects current network metrics.
    public func collectMetrics() async -> NetworkMetrics {
        let (interfaces, totalReceived, totalSent) = getInterfaceStats()

        let now = Date()
        var downloadSpeed: Double = 0
        var uploadSpeed: Double = 0

        if let previousTime = previousTimestamp {
            let elapsed = now.timeIntervalSince(previousTime)
            if elapsed > 0 {
                let receivedDelta = totalReceived > previousBytes.received
                    ? totalReceived - previousBytes.received
                    : 0
                let sentDelta = totalSent > previousBytes.sent
                    ? totalSent - previousBytes.sent
                    : 0

                downloadSpeed = Double(receivedDelta) / elapsed
                uploadSpeed = Double(sentDelta) / elapsed
            }
        }

        previousBytes = (totalReceived, totalSent)
        previousTimestamp = now

        return NetworkMetrics(
            interfaces: interfaces,
            downloadSpeed: downloadSpeed,
            uploadSpeed: uploadSpeed,
            totalDownloaded: totalReceived,
            totalUploaded: totalSent,
            timestamp: now
        )
    }

    // MARK: - Private Methods

    private func getInterfaceStats() -> (interfaces: [NetworkInterfaceMetrics], totalReceived: UInt64, totalSent: UInt64) {
        var interfaces: [NetworkInterfaceMetrics] = []
        var totalReceived: UInt64 = 0
        var totalSent: UInt64 = 0

        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0, let firstAddr = ifaddr else {
            return ([], 0, 0)
        }
        defer { freeifaddrs(ifaddr) }

        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            let name = String(cString: interface.ifa_name)

            guard interface.ifa_addr.pointee.sa_family == UInt8(AF_LINK) else {
                continue
            }

            guard name.hasPrefix("en") || name.hasPrefix("utun") || name.hasPrefix("bridge") else {
                continue
            }

            guard let data = interface.ifa_data else { continue }

            let networkData = data.assumingMemoryBound(to: if_data.self).pointee

            let bytesReceived = UInt64(networkData.ifi_ibytes)
            let bytesSent = UInt64(networkData.ifi_obytes)
            let packetsReceived = UInt64(networkData.ifi_ipackets)
            let packetsSent = UInt64(networkData.ifi_opackets)
            let errorsIn = UInt64(networkData.ifi_ierrors)
            let errorsOut = UInt64(networkData.ifi_oerrors)

            let isPrimary = name == "en0"
            let displayName = getDisplayName(for: name)

            interfaces.append(NetworkInterfaceMetrics(
                name: name,
                displayName: displayName,
                isPrimary: isPrimary,
                bytesReceived: bytesReceived,
                bytesSent: bytesSent,
                packetsReceived: packetsReceived,
                packetsSent: packetsSent,
                errorsIn: errorsIn,
                errorsOut: errorsOut
            ))

            if name.hasPrefix("en") {
                totalReceived += bytesReceived
                totalSent += bytesSent
            }
        }

        interfaces.sort { $0.isPrimary && !$1.isPrimary }

        return (interfaces, totalReceived, totalSent)
    }

    private func getDisplayName(for interfaceName: String) -> String {
        switch interfaceName {
        case "en0": return "Wi-Fi"
        case "en1": return "Ethernet"
        case "lo0": return "Loopback"
        case "bridge0": return "Bridge"
        default:
            if interfaceName.hasPrefix("utun") {
                return "VPN"
            }
            return interfaceName
        }
    }
}
