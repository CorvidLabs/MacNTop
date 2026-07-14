---
module: macntop
version: 2
status: active
files:
  - Sources/MacNTop/App/AppDelegate.swift
  - Sources/MacNTop/App/Application+State.swift
  - Sources/MacNTop/Core/MetricsCoordinator.swift
  - Sources/MacNTop/MenuBar/StatusBarController.swift
  - Sources/MacNTop/MenuBar/StatusBarIconRenderer.swift
  - Sources/MacNTop/Models/CPUMetrics.swift
  - Sources/MacNTop/Models/DiskMetrics.swift
  - Sources/MacNTop/Models/GPUMetrics.swift
  - Sources/MacNTop/Models/HistoricalData.swift
  - Sources/MacNTop/Models/MemoryMetrics.swift
  - Sources/MacNTop/Models/NetworkMetrics.swift
  - Sources/MacNTop/Models/PowerMetrics.swift
  - Sources/MacNTop/Models/ProcessMetrics.swift
  - Sources/MacNTop/Models/SystemInfo.swift
  - Sources/MacNTop/Models/ThermalMetrics.swift
  - Sources/MacNTop/Services/CPUMonitor.swift
  - Sources/MacNTop/Services/DiskMonitor.swift
  - Sources/MacNTop/Services/GPUMonitor.swift
  - Sources/MacNTop/Services/MemoryMonitor.swift
  - Sources/MacNTop/Services/NetworkMonitor.swift
  - Sources/MacNTop/Services/PowerMonitor.swift
  - Sources/MacNTop/Services/ProcessMonitor.swift
  - Sources/MacNTop/Services/SystemInfoService.swift
  - Sources/MacNTop/Services/ThermalMonitor.swift
  - Sources/MacNTop/Utilities/ByteFormatter.swift
  - Sources/MacNTop/Views/CPUView.swift
  - Sources/MacNTop/Views/Components/CRTEffectView.swift
  - Sources/MacNTop/Views/Components/RetroTheme.swift
  - Sources/MacNTop/Views/Components/SparklineView.swift
  - Sources/MacNTop/Views/DashboardView.swift
  - Sources/MacNTop/Views/DashboardViewController.swift
  - Sources/MacNTop/Views/DashboardWindow.swift
  - Sources/MacNTop/Views/DiskView.swift
  - Sources/MacNTop/Views/MemoryView.swift
  - Sources/MacNTop/Views/NetworkView.swift
  - Sources/MacNTop/Views/ProcessListView.swift
  - Sources/MacNTop/Views/StaticInfoView.swift
  - Sources/MacNTop/Views/SystemStatusView.swift

db_tables: []
depends_on: []
---

# MacNTop System Monitor

## Purpose

Provide the existing local-only macOS menu-bar system monitor, metrics services, historical models, status UI, themes, and window behavior for macOS 14 and newer.

## Public API

| Symbol | Existing contract group |
|---|---|
| `Theme` | Application theme state |
| `colors` | Application theme state |
| `current` | Application theme state |
| `setCurrent` | Application theme state |
| `retroGreen` | Application theme state |
| `amber` | Application theme state |
| `blueIce` | Application theme state |
| `matrix` | Application theme state |
| `dracula` | Application theme state |
| `light` | Application theme state |
| `MetricsCoordinator` | Metrics coordination |
| `onMetricsUpdate` | Metrics coordination |
| `start` | Metrics coordination |
| `stop` | Metrics coordination |
| `collectOnce` | Metrics coordination |
| `getSystemInfo` | Metrics coordination |
| `getCPUHistory` | Metrics coordination |
| `getMemoryHistory` | Metrics coordination |
| `getDownloadHistory` | Metrics coordination |
| `getUploadHistory` | Metrics coordination |
| `getGPUHistory` | Metrics coordination |
| `MetricsSnapshot` | Metrics coordination |
| `cpu` | Metrics snapshot value |
| `memory` | Metrics snapshot value |
| `network` | Metrics snapshot value |
| `disk` | Metrics snapshot value |
| `processes` | Metrics snapshot value |
| `gpu` | Metrics snapshot value |
| `thermal` | Metrics snapshot value |
| `power` | Metrics snapshot value |
| `cpuHistory` | Metrics history value |
| `memoryHistory` | Metrics history value |
| `downloadHistory` | Metrics history value |
| `uploadHistory` | Metrics history value |
| `gpuHistory` | Metrics history value |
| `timestamp` | Metrics snapshot value |
| `init` | Value initialization |
| `StatusBarController` | Menu-bar presentation |
| `setup` | Menu-bar presentation |
| `updateIcon` | Menu-bar presentation |
| `updateDashboard` | Menu-bar presentation |
| `openWindow` | Window presentation |
| `closeWindow` | Window presentation |
| `isWindowOpen` | Window presentation |
| `showPopover` | Menu-bar presentation |
| `hidePopover` | Menu-bar presentation |
| `cleanup` | Menu-bar lifecycle |
| `StatusBarIconRenderer` | Menu-bar presentation |
| `renderIcon` | Menu-bar presentation |
| `renderPlaceholderIcon` | Menu-bar fallback presentation |
| `CPUCoreMetrics` | CPU model |
| `id` | Model identity |
| `user` | CPU model value |
| `system` | CPU model value |
| `idle` | CPU model value |
| `nice` | CPU model value |
| `total` | CPU derived value |
| `CPUMetrics` | CPU model |
| `cores` | CPU model value |
| `averageUsage` | CPU derived value |
| `averageUser` | CPU derived value |
| `averageSystem` | CPU derived value |
| `DiskVolumeMetrics` | Disk model |
| `mountPoint` | Disk model value |
| `name` | Display identity |
| `fileSystem` | Disk model value |
| `totalSpace` | Disk model value |
| `usedSpace` | Disk model value |
| `availableSpace` | Disk model value |
| `usagePercent` | Disk derived value |
| `formattedTotal` | Disk display value |
| `formattedUsed` | Disk display value |
| `formattedAvailable` | Disk display value |
| `DiskIOMetrics` | Disk I/O model |
| `readBytesPerSecond` | Disk I/O value |
| `writeBytesPerSecond` | Disk I/O value |
| `totalBytesRead` | Disk I/O value |
| `totalBytesWritten` | Disk I/O value |
| `formattedReadSpeed` | Disk display value |
| `formattedWriteSpeed` | Disk display value |
| `DiskMetrics` | Disk model |
| `volumes` | Disk model value |
| `io` | Disk model value |
| `GPUMetrics` | GPU model |
| `utilization` | GPU model value |
| `frequencyMHz` | GPU model value |
| `powerWatts` | GPU model value |
| `temperatureCelsius` | GPU model value |
| `isAvailable` | Availability state |
| `unavailable` | Availability fallback |
| `formattedUtilization` | GPU display value |
| `formattedFrequency` | GPU display value |
| `formattedPower` | GPU display value |
| `formattedTemperature` | GPU display value |
| `HistoricalData` | Bounded history |
| `add` | Bounded history mutation |
| `values` | Bounded history observation |
| `storedCount` | Bounded history observation |
| `isEmpty` | Bounded history observation |
| `latest` | Bounded history observation |
| `clear` | Bounded history mutation |
| `minimum` | Numeric history summary |
| `maximum` | Numeric history summary |
| `average` | Numeric history summary |
| `SwapMetrics` | Memory model |
| `used` | Memory model value |
| `free` | Memory model value |
| `isActive` | Swap derived state |
| `zero` | Safe zero model |
| `MemoryMetrics` | Memory model |
| `active` | Memory model value |
| `wired` | Memory model value |
| `compressed` | Memory model value |
| `inactive` | Memory model value |
| `appMemory` | Memory model value |
| `swap` | Memory model value |
| `available` | Memory derived value |
| `cached` | Memory derived value |
| `pressure` | Memory pressure value |
| `formattedActive` | Memory display value |
| `formattedWired` | Memory display value |
| `formattedCompressed` | Memory display value |
| `NetworkInterfaceMetrics` | Network model |
| `displayName` | Network display identity |
| `isPrimary` | Network interface state |
| `bytesReceived` | Network counter |
| `bytesSent` | Network counter |
| `packetsReceived` | Network counter |
| `packetsSent` | Network counter |
| `errorsIn` | Network counter |
| `errorsOut` | Network counter |
| `NetworkMetrics` | Network model |
| `interfaces` | Network model value |
| `downloadSpeed` | Network rate |
| `uploadSpeed` | Network rate |
| `totalDownloaded` | Network aggregate |
| `totalUploaded` | Network aggregate |
| `formattedDownloadSpeed` | Network display value |
| `formattedUploadSpeed` | Network display value |
| `formattedTotalDownloaded` | Network display value |
| `formattedTotalUploaded` | Network display value |
| `PowerMetrics` | Power model |
| `systemPower` | Power model value |
| `cpuPower` | Power model value |
| `gpuPower` | Power model value |
| `anePower` | Power model value |
| `dramPower` | Power model value |
| `isPluggedIn` | Power source state |
| `batteryLevel` | Battery state |
| `isCharging` | Battery state |
| `formattedSystemPower` | Power display value |
| `formattedCPUPower` | Power display value |
| `formattedGPUPower` | Power display value |
| `formattedBatteryLevel` | Battery display value |
| `totalComponentPower` | Power derived value |
| `ProcessItem` | Process model |
| `pid` | Process identity |
| `cpuUsage` | Process model value |
| `memoryUsage` | Process model value |
| `threadCount` | Process model value |
| `formattedCPU` | Process display value |
| `formattedMemory` | Process display value |
| `ProcessMetrics` | Process collection model |
| `topByCPU` | Process ranking |
| `topByMemory` | Process ranking |
| `totalProcessCount` | Process aggregate |
| `SystemInfo` | System information model |
| `hostname` | System information value |
| `osVersion` | System information value |
| `osName` | System information value |
| `uptime` | System information value |
| `cpuModel` | System information value |
| `cpuCoreCount` | System information value |
| `cpuLogicalCoreCount` | System information value |
| `totalMemory` | System information value |
| `gpuModel` | System information value |
| `gpuMemory` | System information value |
| `localIP` | System information value |
| `kernelVersion` | System information value |
| `username` | System information value |
| `formattedUptime` | System display value |
| `formattedGPUMemory` | System display value |
| `ThermalState` | Thermal state model |
| `isWarning` | Thermal derived state |
| `ThermalMetrics` | Thermal model |
| `state` | Thermal model value |
| `cpuTemperature` | Thermal model value |
| `gpuTemperature` | Thermal model value |
| `socTemperature` | Thermal model value |
| `fanSpeedRPM` | Thermal model value |
| `formattedCPUTemp` | Thermal display value |
| `formattedGPUTemp` | Thermal display value |
| `formattedSoCTemp` | Thermal display value |
| `formattedFanSpeed` | Thermal display value |
| `basic` | Thermal fallback value |
| `nominal` | Thermal state value |
| `fair` | Thermal state value |
| `serious` | Thermal state value |
| `critical` | Thermal state value |
| `CPUMonitor` | Local monitor actor |
| `collectMetrics` | Local monitor sampling |
| `DiskMonitor` | Local monitor actor |
| `GPUMonitor` | Local monitor actor |
| `MemoryMonitor` | Local monitor actor |
| `NetworkMonitor` | Local monitor actor |
| `PowerMonitor` | Local monitor actor |
| `ProcessMonitor` | Local monitor actor |
| `SystemInfoService` | Local information actor |
| `collectSystemInfo` | Local information sampling |
| `ThermalMonitor` | Local monitor actor |
| `ByteFormatter` | Display formatting |
| `format` | Display formatting |
| `formatRate` | Display formatting |
| `formatUptime` | Display formatting |
| `formatPercent` | Display formatting |
| `CPUView` | Snapshot presentation |
| `configure` | Snapshot presentation |
| `CRTEffectView` | Visual effect presentation |
| `scanlineIntensity` | Visual effect setting |
| `vignetteIntensity` | Visual effect setting |
| `showScanlines` | Visual effect setting |
| `showVignette` | Visual effect setting |
| `draw` | Visual rendering |
| `hitTest` | Visual input behavior |
| `ThemeColors` | Theme palette |
| `background` | Theme palette value |
| `primaryText` | Theme palette value |
| `secondaryText` | Theme palette value |
| `accent` | Theme palette value |
| `warning` | Theme palette value |
| `barBackground` | Theme palette value |
| `separator` | Theme palette value |
| `Themes` | Theme catalog |
| `all` | Theme catalog value |
| `RetroTheme` | Retro presentation utility |
| `glowGreen` | Retro palette value |
| `glowCyan` | Retro palette value |
| `monoFont` | Retro typography |
| `smallMono` | Retro typography |
| `regularMono` | Retro typography |
| `largeMono` | Retro typography |
| `blockFull` | Retro bar glyph |
| `blockHigh` | Retro bar glyph |
| `blockMed` | Retro bar glyph |
| `blockLow` | Retro bar glyph |
| `blockEmpty` | Retro bar glyph |
| `asciiBar` | Retro bar rendering |
| `simpleBar` | Retro bar rendering |
| `colorForUsage` | Usage palette selection |
| `glowShadow` | Retro visual effect |
| `applyGlow` | Retro visual effect |
| `SparklineView` | History presentation |
| `setValues` | History presentation |
| `DashboardView` | Snapshot presentation |
| `staticInfoView` | Dashboard component |
| `cpuView` | Dashboard component |
| `systemStatusView` | Dashboard component |
| `memoryView` | Dashboard component |
| `networkView` | Dashboard component |
| `diskView` | Dashboard component |
| `processListView` | Dashboard component |
| `DashboardViewController` | Dashboard lifecycle |
| `loadView` | Dashboard lifecycle |
| `viewDidLoad` | Dashboard lifecycle |
| `updateMetrics` | Snapshot presentation |
| `DashboardWindow` | Window presentation |
| `showWindow` | Window presentation |
| `canBecomeKey` | Window behavior |
| `canBecomeMain` | Window behavior |
| `close` | Window lifecycle |
| `DiskView` | Snapshot presentation |
| `MemoryView` | Snapshot presentation |
| `NetworkView` | Snapshot presentation |
| `ProcessListView` | Snapshot presentation |
| `StaticInfoView` | Snapshot presentation |
| `updateUptime` | Snapshot presentation |
| `SystemStatusView` | Snapshot presentation |

### Application Interface

The `MacNTop` executable exposes the existing menu-bar popover, floating dashboard window, theme selection, CPU, memory, network, disk, process, GPU, power and thermal monitoring, historical sparklines, and local preference persistence described in the README.

### Coordination and Monitoring

- `MetricsCoordinator` owns the sampling cadence and produces `MetricsSnapshot` values from `CPUMonitor`, `MemoryMonitor`, `NetworkMonitor`, `DiskMonitor`, `ProcessMonitor`, `GPUMonitor`, `PowerMonitor`, `ThermalMonitor`, and `SystemInfoService` actors.
- `StatusBarController` and `StatusBarIconRenderer` present the menu-bar entry point and current status without owning metric collection.

### Metric Models and Formatting

- `CPUCoreMetrics`, `CPUMetrics`, `SwapMetrics`, `MemoryMetrics`, `NetworkInterfaceMetrics`, `NetworkMetrics`, `DiskVolumeMetrics`, `DiskIOMetrics`, `DiskMetrics`, `ProcessItem`, `ProcessMetrics`, `GPUMetrics`, `PowerMetrics`, `ThermalState`, `ThermalMetrics`, and `SystemInfo` represent sampled local state.
- `HistoricalData` provides bounded chronological samples and `ByteFormatter` formats byte quantities for presentation.

### Presentation and Preferences

- `DashboardView`, `DashboardViewController`, `DashboardWindow`, `CPUView`, `MemoryView`, `NetworkView`, `DiskView`, `ProcessListView`, `StaticInfoView`, and `SystemStatusView` render the current snapshot.
- `SparklineView`, `CRTEffectView`, `Theme`, `ThemeColors`, `Themes`, and `RetroTheme` provide historical visualization, styling, and persisted theme selection.

## Invariants

1. Metrics remain local to the device and are not transmitted or persisted beyond existing preferences and in-memory history.
2. Monitor services preserve actor and `Sendable` isolation across collection and UI updates.
3. System API failures or restricted metrics degrade through existing optional/error behavior rather than fabricating values.
4. Historical series retain their configured capacity and chronological ordering.
5. UI, menu, theme, and window state changes remain on the appropriate macOS application isolation boundary.
6. Sampling remains bounded by the existing coordinator cadence and never launches publication, telemetry, or remote transport work.
7. Formatting and view helpers present supplied metrics without mutating the monitor actors' underlying state.

## Behavioral Examples

```
Given MacNTop is running on a supported Mac
When the metrics coordinator refreshes the dashboard
Then each available monitor updates its local model and UI without transmitting system data
```

## Error Cases

| Error | When | Behavior |
|-------|------|----------|
| Unsupported metric | The current Mac does not expose a requested sensor or API | Preserve the existing unavailable value behavior |
| Permission restriction | Process or system information is inaccessible | Skip or report the metric without crashing the app |
| Collection failure | A monitor cannot sample its system API | Surface the existing error or retain safe UI state |

## Dependencies

- Swift 6 and macOS 14 or newer
- AppKit, IOKit, Metal, Darwin system APIs
- AppState for existing theme persistence

## Change Log

| Version | Date | Changes |
|---------|------|---------|
| 1 | 2026-07-12 | Initial spec |
| 2 | 2026-07-14 | Document all existing Swift surfaces and enforce complete measured SDD coverage through Trust 1.0.0. |

## Export Inventory

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
