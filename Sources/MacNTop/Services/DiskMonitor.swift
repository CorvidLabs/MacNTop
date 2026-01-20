import Foundation
import IOKit

/// Monitor for disk usage and I/O metrics.
public actor DiskMonitor {
    // MARK: - Properties

    private var previousIO: (read: UInt64, write: UInt64) = (0, 0)
    private var previousTimestamp: Date?

    // MARK: - Public Methods

    /// Collects current disk metrics.
    public func collectMetrics() async -> DiskMetrics {
        let volumes = getVolumeStats()
        let io = getIOStats()

        return DiskMetrics(
            volumes: volumes,
            io: io,
            timestamp: Date()
        )
    }

    // MARK: - Private Methods

    private func getVolumeStats() -> [DiskVolumeMetrics] {
        var volumes: [DiskVolumeMetrics] = []

        let fileManager = FileManager.default
        guard let mountedVolumes = fileManager.mountedVolumeURLs(
            includingResourceValuesForKeys: [
                .volumeNameKey,
                .volumeTotalCapacityKey,
                .volumeAvailableCapacityKey,
                .volumeIsLocalKey,
                .volumeIsReadOnlyKey
            ],
            options: [.skipHiddenVolumes]
        ) else {
            return volumes
        }

        for volumeURL in mountedVolumes {
            guard let resourceValues = try? volumeURL.resourceValues(forKeys: [
                .volumeNameKey,
                .volumeTotalCapacityKey,
                .volumeAvailableCapacityKey,
                .volumeIsLocalKey
            ]) else {
                continue
            }

            guard resourceValues.volumeIsLocal == true else { continue }

            let name = resourceValues.volumeName ?? volumeURL.lastPathComponent
            let total = UInt64(resourceValues.volumeTotalCapacity ?? 0)
            let available = UInt64(resourceValues.volumeAvailableCapacity ?? 0)
            let used = total > available ? total - available : 0

            var statFS = statfs()
            guard statfs(volumeURL.path, &statFS) == 0 else { continue }

            let fileSystem = withUnsafePointer(to: statFS.f_fstypename) { ptr in
                ptr.withMemoryRebound(to: CChar.self, capacity: Int(MFSTYPENAMELEN)) { cPtr in
                    String(cString: cPtr)
                }
            }

            volumes.append(DiskVolumeMetrics(
                mountPoint: volumeURL.path,
                name: name,
                fileSystem: fileSystem,
                totalSpace: total,
                usedSpace: used,
                availableSpace: available
            ))
        }

        volumes.sort { $0.mountPoint == "/" && $1.mountPoint != "/" }

        return volumes
    }

    private func getIOStats() -> DiskIOMetrics {
        let now = Date()
        var totalBytesRead: UInt64 = 0
        var totalBytesWritten: UInt64 = 0

        let matchingDict = IOServiceMatching("IOBlockStorageDriver")

        var iterator: io_iterator_t = 0
        let mainPort: mach_port_t
        if #available(macOS 12.0, *) {
            mainPort = kIOMainPortDefault
        } else {
            mainPort = kIOMasterPortDefault
        }
        let result = IOServiceGetMatchingServices(mainPort, matchingDict, &iterator)

        if result == KERN_SUCCESS {
            var service = IOIteratorNext(iterator)
            while service != 0 {
                var properties: Unmanaged<CFMutableDictionary>?
                if IORegistryEntryCreateCFProperties(service, &properties, kCFAllocatorDefault, 0) == KERN_SUCCESS {
                    if let props = properties?.takeRetainedValue() as? [String: Any],
                       let stats = props["Statistics"] as? [String: Any] {
                        if let bytesRead = stats["Bytes (Read)"] as? UInt64 {
                            totalBytesRead += bytesRead
                        }
                        if let bytesWritten = stats["Bytes (Write)"] as? UInt64 {
                            totalBytesWritten += bytesWritten
                        }
                    }
                }
                IOObjectRelease(service)
                service = IOIteratorNext(iterator)
            }
            IOObjectRelease(iterator)
        }

        var readSpeed: Double = 0
        var writeSpeed: Double = 0

        if let previousTime = previousTimestamp {
            let elapsed = now.timeIntervalSince(previousTime)
            if elapsed > 0 {
                let readDelta = totalBytesRead > previousIO.read
                    ? totalBytesRead - previousIO.read
                    : 0
                let writeDelta = totalBytesWritten > previousIO.write
                    ? totalBytesWritten - previousIO.write
                    : 0

                readSpeed = Double(readDelta) / elapsed
                writeSpeed = Double(writeDelta) / elapsed
            }
        }

        previousIO = (totalBytesRead, totalBytesWritten)
        previousTimestamp = now

        return DiskIOMetrics(
            readBytesPerSecond: readSpeed,
            writeBytesPerSecond: writeSpeed,
            totalBytesRead: totalBytesRead,
            totalBytesWritten: totalBytesWritten,
            timestamp: now
        )
    }
}
