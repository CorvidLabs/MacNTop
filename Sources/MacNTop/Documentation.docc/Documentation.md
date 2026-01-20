# ``MacNTop``

A macOS menu bar system monitor with retro CRT terminal aesthetics.

## Overview

MacNTop provides real-time system monitoring in a retro-styled popover accessible from the menu bar. It displays CPU usage per core, memory breakdown, network speeds, disk usage, and top processes.

### Features

- **Live Metrics** - CPU, memory, network, disk, and process monitoring
- **Retro Aesthetics** - CRT scanlines, phosphor glow, vignette effects
- **Multiple Themes** - Six color themes including Retro Green, Amber CRT, Matrix, and Dracula
- **Persistent Settings** - Theme choice saved via AppState

## Topics

### Essentials

- ``AppDelegate``
- ``StatusBarController``
- ``MetricsCoordinator``

### State Management

- ``AppTheme``
- ``ThemeColors``
- ``Themes``

### Monitoring Services

- ``CPUMonitor``
- ``MemoryMonitor``
- ``NetworkMonitor``
- ``DiskMonitor``
- ``ProcessMonitor``

### Data Models

- ``CPUMetrics``
- ``MemoryMetrics``
- ``NetworkMetrics``
- ``DiskMetrics``
- ``ProcessMetrics``
- ``MetricsSnapshot``
- ``SystemInfo``

### Views

- ``DashboardWindow``
- ``DashboardView``
- ``DashboardViewController``
- ``CPUView``
- ``MemoryView``
- ``NetworkView``
- ``DiskView``
- ``ProcessListView``
- ``StaticInfoView``

### Theming

- ``RetroTheme``
- ``CRTEffectView``
