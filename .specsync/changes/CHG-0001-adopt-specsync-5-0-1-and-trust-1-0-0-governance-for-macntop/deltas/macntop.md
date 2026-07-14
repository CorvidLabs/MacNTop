# macntop

## MODIFIED

### REQUIREMENT REQ-macntop-001
CPU and memory monitors SHALL sample local utilization, core, pressure, swap, and capacity data into the existing `Sendable` metric models without transmitting it.

Acceptance Criteria
- Existing CPU and memory model and monitor tests pass, and the verification lane performs no network or publication command.

### REQUIREMENT REQ-macntop-002
Network and disk monitors SHALL report per-interface or per-volume state and aggregate throughput while preserving unavailable-counter and first-sample behavior.

Acceptance Criteria
- Existing network and disk model and monitor tests cover aggregation, first samples, volumes, and unavailable counters.

### REQUIREMENT REQ-macntop-003
Process, GPU, power, thermal, and system-information services SHALL expose only values available from the current Mac and SHALL degrade through their existing optional or safe fallback paths.

Acceptance Criteria
- Existing service and model tests pass for supported values and unavailable or fallback states.

### REQUIREMENT REQ-macntop-004
`MetricsCoordinator` SHALL isolate shared sampling state in its actor, refresh the complete snapshot on the existing cadence, and prevent one unavailable monitor from crashing unrelated collection.

Acceptance Criteria
- Coordinator tests pass for snapshot refresh, history updates, and partial monitor availability.

### REQUIREMENT REQ-macntop-005
`HistoricalData` SHALL retain samples in chronological order, enforce its configured capacity, and preserve its existing numeric summary behavior.

Acceptance Criteria
- Historical data tests pass for append order, capacity eviction, clearing, and numeric summaries.

### REQUIREMENT REQ-macntop-006
`ByteFormatter` and metric display helpers SHALL preserve the existing human-readable units, percentages, rates, temperatures, and unavailable-value presentation.

Acceptance Criteria
- Formatter and model-derived display tests pass for representative values and unavailable data.

### REQUIREMENT REQ-macntop-007
The status-bar controller and icon renderer SHALL preserve the existing menu-bar popover, dashboard toggle, current status rendering, and application lifecycle behavior.

Acceptance Criteria
- The macOS build and existing menu-bar controller and renderer tests pass without launching the app.

### REQUIREMENT REQ-macntop-008
The dashboard controller and window SHALL preserve floating-window placement, visibility, resizing, and notification behavior on the main application isolation boundary.

Acceptance Criteria
- Existing dashboard controller and window tests pass on the macOS runner.

### REQUIREMENT REQ-macntop-009
CPU, memory, network, disk, process, static-information, and system-status views SHALL render the supplied snapshot without directly collecting or transmitting metrics.

Acceptance Criteria
- Existing view tests and the macOS build pass, and source review confirms views consume supplied models rather than monitor actors.

### REQUIREMENT REQ-macntop-010
`SparklineView`, `CRTEffectView`, and the retro theme types SHALL preserve the existing bounded visual history, optional CRT treatment, palette selection, and theme persistence.

Acceptance Criteria
- Existing sparkline, CRT, theme, and application-state tests pass on the macOS runner.

### REQUIREMENT REQ-macntop-011
All monitor, model, coordinator, and UI concurrency boundaries SHALL preserve the existing actor, `Sendable`, and main-application isolation guarantees.

Acceptance Criteria
- Swift 6 compilation and the complete test suite pass with the repository's existing strict concurrency settings.

### REQUIREMENT REQ-macntop-012
Native verification SHALL build the macOS executable and pass its complete test suite without launching the interactive application, transmitting metrics, deploying, or publishing a release.

Acceptance Criteria
- `swift build` and `swift test` pass, while the verification lane contains no run, deploy, release, or publication step.

## ADDED

### SPEC SECTION Export Inventory

The executable's existing Swift-visible surface is grouped below. Data properties are value observations; collection methods sample local system APIs; view methods render supplied values.

- Application and theme state: `Theme`, `colors`, `current`, `setCurrent`, `retroGreen`, `amber`, `blueIce`, `matrix`, `dracula`, `light`.
- Coordination: `MetricsCoordinator`, `onMetricsUpdate`, `start`, `stop`, `collectOnce`, `getSystemInfo`, `getCPUHistory`, `getMemoryHistory`, `getDownloadHistory`, `getUploadHistory`, `getGPUHistory`, `MetricsSnapshot`, `cpu`, `memory`, `network`, `disk`, `processes`, `gpu`, `thermal`, `power`, `cpuHistory`, `memoryHistory`, `downloadHistory`, `uploadHistory`, `gpuHistory`, `timestamp`, `init`.
- Menu bar: `StatusBarController`, `setup`, `updateIcon`, `updateDashboard`, `openWindow`, `closeWindow`, `isWindowOpen`, `showPopover`, `hidePopover`, `cleanup`, `StatusBarIconRenderer`, `renderIcon`, `renderPlaceholderIcon`.
- CPU: `CPUCoreMetrics`, `id`, `user`, `system`, `idle`, `nice`, `total`, `CPUMetrics`, `cores`, `averageUsage`, `averageUser`, `averageSystem`.
- Disk: `DiskVolumeMetrics`, `mountPoint`, `name`, `fileSystem`, `totalSpace`, `usedSpace`, `availableSpace`, `usagePercent`, `formattedTotal`, `formattedUsed`, `formattedAvailable`, `DiskIOMetrics`, `readBytesPerSecond`, `writeBytesPerSecond`, `totalBytesRead`, `totalBytesWritten`, `formattedReadSpeed`, `formattedWriteSpeed`, `DiskMetrics`, `volumes`, `io`.
- GPU: `GPUMetrics`, `utilization`, `frequencyMHz`, `powerWatts`, `temperatureCelsius`, `isAvailable`, `unavailable`, `formattedUtilization`, `formattedFrequency`, `formattedPower`, `formattedTemperature`.
- History: `HistoricalData`, `add`, `values`, `storedCount`, `isEmpty`, `latest`, `clear`, `minimum`, `maximum`, `average`.
- Memory: `SwapMetrics`, `used`, `free`, `isActive`, `zero`, `MemoryMetrics`, `active`, `wired`, `compressed`, `inactive`, `appMemory`, `swap`, `available`, `cached`, `pressure`, `formattedActive`, `formattedWired`, `formattedCompressed`.
- Network: `NetworkInterfaceMetrics`, `displayName`, `isPrimary`, `bytesReceived`, `bytesSent`, `packetsReceived`, `packetsSent`, `errorsIn`, `errorsOut`, `NetworkMetrics`, `interfaces`, `downloadSpeed`, `uploadSpeed`, `totalDownloaded`, `totalUploaded`, `formattedDownloadSpeed`, `formattedUploadSpeed`, `formattedTotalDownloaded`, `formattedTotalUploaded`.
- Power: `PowerMetrics`, `systemPower`, `cpuPower`, `gpuPower`, `anePower`, `dramPower`, `isPluggedIn`, `batteryLevel`, `isCharging`, `formattedSystemPower`, `formattedCPUPower`, `formattedGPUPower`, `formattedBatteryLevel`, `totalComponentPower`.
- Processes: `ProcessItem`, `pid`, `cpuUsage`, `memoryUsage`, `threadCount`, `formattedCPU`, `formattedMemory`, `ProcessMetrics`, `topByCPU`, `topByMemory`, `totalProcessCount`.
- System information: `SystemInfo`, `hostname`, `osVersion`, `osName`, `uptime`, `cpuModel`, `cpuCoreCount`, `cpuLogicalCoreCount`, `totalMemory`, `gpuModel`, `gpuMemory`, `localIP`, `kernelVersion`, `username`, `formattedUptime`, `formattedGPUMemory`.
- Thermal: `ThermalState`, `isWarning`, `ThermalMetrics`, `state`, `cpuTemperature`, `gpuTemperature`, `socTemperature`, `fanSpeedRPM`, `formattedCPUTemp`, `formattedGPUTemp`, `formattedSoCTemp`, `formattedFanSpeed`, `basic`, `nominal`, `fair`, `serious`, `critical`.
- Monitor services: `CPUMonitor`, `collectMetrics`, `DiskMonitor`, `GPUMonitor`, `MemoryMonitor`, `NetworkMonitor`, `PowerMonitor`, `ProcessMonitor`, `SystemInfoService`, `collectSystemInfo`, `ThermalMonitor`.
- Formatting: `ByteFormatter`, `format`, `formatRate`, `formatUptime`, `formatPercent`.
- Views and effects: `CPUView`, `configure`, `CRTEffectView`, `scanlineIntensity`, `vignetteIntensity`, `showScanlines`, `showVignette`, `draw`, `hitTest`, `ThemeColors`, `background`, `primaryText`, `secondaryText`, `accent`, `warning`, `barBackground`, `separator`, `Themes`, `all`, `RetroTheme`, `glowGreen`, `glowCyan`, `monoFont`, `smallMono`, `regularMono`, `largeMono`, `blockFull`, `blockHigh`, `blockMed`, `blockLow`, `blockEmpty`, `asciiBar`, `simpleBar`, `colorForUsage`, `glowShadow`, `applyGlow`, `SparklineView`, `setValues`, `DashboardView`, `staticInfoView`, `cpuView`, `systemStatusView`, `memoryView`, `networkView`, `diskView`, `processListView`, `DashboardViewController`, `loadView`, `viewDidLoad`, `updateMetrics`, `DashboardWindow`, `showWindow`, `canBecomeKey`, `canBecomeMain`, `close`, `DiskView`, `MemoryView`, `NetworkView`, `ProcessListView`, `StaticInfoView`, `updateUptime`, `SystemStatusView`.
