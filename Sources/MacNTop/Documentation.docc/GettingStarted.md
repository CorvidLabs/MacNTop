# Getting Started

Build and run MacNTop to monitor your system from the menu bar.

## Overview

MacNTop is a Swift-based macOS menu bar app that provides real-time system monitoring with a retro terminal aesthetic.

## Building

### Requirements

- macOS 14.0 or later
- Swift 6.0 or later
- Xcode 16+ (optional, for IDE features)

### From Command Line

```bash
# Clone the repository
git clone https://github.com/CorvidLabs/MacNTop.git
cd MacNTop

# Build release version
swift build -c release

# Run
.build/release/MacNTop
```

### During Development

```bash
# Build and run debug version
swift run
```

## Usage

### Menu Bar Icon

Once running, MacNTop appears in your menu bar showing CPU and memory percentages:

```
C:28% M:55%
```

- **Left-click** opens the dashboard popover
- **Right-click** opens the context menu

### Dashboard

The dashboard displays:

1. **Static Info** - Hostname, OS version, CPU model, memory, GPU
2. **CPU** - Per-core usage bars and sparkline history
3. **Memory** - Segmented bar showing wired/active/compressed/free
4. **Network** - Upload/download speeds with sparklines
5. **Disk** - Volume usage bars and I/O speeds
6. **Processes** - Top 10 by CPU or memory

### Changing Themes

1. Right-click the menu bar icon
2. Hover over "Theme"
3. Select from available themes:
   - Retro Green (default)
   - Amber CRT
   - Blue Ice
   - Matrix
   - Dracula
   - Light

Your theme choice is automatically saved.

## Architecture

MacNTop uses Swift's actor model for thread-safe metric collection:

```
┌─────────────────┐
│ MetricsCoord    │ ← Orchestrates all monitors
└────────┬────────┘
         │
    ┌────┴────┬────────┬────────┬────────┐
    ▼         ▼        ▼        ▼        ▼
┌───────┐ ┌───────┐ ┌───────┐ ┌───────┐ ┌───────┐
│ CPU   │ │ Mem   │ │ Net   │ │ Disk  │ │ Proc  │
│Monitor│ │Monitor│ │Monitor│ │Monitor│ │Monitor│
└───────┘ └───────┘ └───────┘ └───────┘ └───────┘
```

Each monitor is an actor that collects metrics asynchronously and returns Sendable data models.
