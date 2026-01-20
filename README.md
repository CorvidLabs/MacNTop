# MacNTop

A macOS menu bar system monitor with retro CRT terminal aesthetics.

[![Swift 6.0+](https://img.shields.io/badge/Swift-6.0+-orange.svg)](https://swift.org)
[![macOS 14+](https://img.shields.io/badge/macOS-14+-blue.svg)](https://www.apple.com/macos)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

<p align="center">
  <img src="docs/screenshot.png" alt="MacNTop Screenshot" width="480">
</p>

## Features

### Live Monitoring
- **CPU Usage** - Per-core usage with sparkline graphs
- **Memory** - Active, wired, compressed breakdown with segmented bar
- **Network** - Upload/download speeds with real-time sparklines
- **Disk** - Volume usage and I/O speeds
- **Processes** - Top 10 by CPU or memory usage

### Retro CRT Aesthetics
- Phosphor glow effects on text
- Scanline overlay
- Vignette darkening at edges
- Multiple color themes

### Themes
- **Retro Green** - Classic green phosphor CRT
- **Amber CRT** - Warm amber terminal
- **Blue Ice** - Cool blue tones
- **Matrix** - Bright green on black
- **Dracula** - Purple/pink dark theme
- **Light** - Light mode for daytime

## Installation

### Requirements
- macOS 14.0 (Sonoma) or later
- Swift 6.0+ / Xcode 16+ (for building)

### Build from Source

```bash
git clone https://github.com/CorvidLabs/MacNTop.git
cd MacNTop
swift build -c release
```

The built app will be at `.build/release/MacNTop`.

### Run

```bash
swift run
```

Or after building:

```bash
.build/release/MacNTop
```

## Usage

### Menu Bar
- **Left-click** - Toggle the dashboard popover
- **Right-click** - Open context menu (Theme selection, About, Quit)

### Dashboard
- **CPU/MEM toggle** in process list - Click to sort by CPU or Memory
- Scroll to see all sections

### Keyboard Shortcuts
- **⌘Q** - Quit (from context menu)

## Architecture

```
MacNTop/
├── Sources/MacNTop/
│   ├── App/
│   │   ├── AppDelegate.swift          # Entry point
│   │   └── Application+State.swift    # AppState theme management
│   ├── MenuBar/
│   │   ├── StatusBarController.swift  # NSStatusItem + popover
│   │   └── StatusBarIconRenderer.swift
│   ├── Models/                        # Sendable data models
│   ├── Services/                      # Actor-based monitors
│   ├── Core/
│   │   └── MetricsCoordinator.swift   # Orchestrates collection
│   ├── Views/                         # AppKit views
│   └── Utilities/
│       └── ByteFormatter.swift
└── Package.swift
```

### Key Technologies
- **Swift Concurrency** - Actors for thread-safe monitoring
- **AppKit** - Native macOS UI
- **AppState** - State management and persistence
- **IOKit** - Low-level system metrics

## System APIs Used

| Metric | API |
|--------|-----|
| CPU | `host_processor_info()` |
| Memory | `host_statistics64(HOST_VM_INFO64)` |
| Network | `getifaddrs()` with `if_data` |
| Disk | `statfs()`, IOKit `IOBlockStorageDriver` |
| Processes | `proc_listallpids()`, `proc_pidinfo()` |

## Dependencies

- [AppState](https://github.com/0xLeif/AppState) - Thread-safe state management

## Configuration

Theme selection is persisted automatically via `UserDefaults`.

## Development

### Code Style

This project follows [CorvidLabs Swift Conventions](https://github.com/CorvidLabs):
- Explicit access control on all declarations
- K&R brace style
- No force unwrapping
- async/await for concurrency
- Sendable conformance for cross-boundary types

### Building Documentation

```bash
swift package generate-documentation
```

### Running Tests

```bash
swift test
```

## Privacy

MacNTop runs entirely locally. No data is collected or transmitted.

## Known Limitations

- Requires distribution outside App Store (uses restricted APIs)
- Disk I/O monitoring requires IOKit access
- Process monitoring limited to current user's processes

## Contributing

1. Fork the repository
2. Create a feature branch
3. Follow CorvidLabs Swift conventions
4. Submit a pull request

## License

MIT License - see [LICENSE](LICENSE) for details.

## Credits

Built by [CorvidLabs](https://github.com/CorvidLabs)

Inspired by:
- [btop](https://github.com/aristocratos/btop) - Resource monitor
- [fastfetch](https://github.com/fastfetch-cli/fastfetch) - System information
