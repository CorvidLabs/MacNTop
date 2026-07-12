---
module: macntop
version: 1
status: active
files:
  - Package.swift

db_tables: []
depends_on: []
---

# MacNTop System Monitor

## Purpose

Provide the existing local-only macOS menu-bar system monitor, metrics services, historical models, status UI, themes, and window behavior for macOS 14 and newer.

## Public API

### Application Interface

The `MacNTop` executable exposes the existing menu-bar popover, floating dashboard window, theme selection, CPU, memory, network, disk, process, GPU, power and thermal monitoring, historical sparklines, and local preference persistence described in the README.

## Invariants

1. Metrics remain local to the device and are not transmitted or persisted beyond existing preferences and in-memory history.
2. Monitor services preserve actor and `Sendable` isolation across collection and UI updates.
3. System API failures or restricted metrics degrade through existing optional/error behavior rather than fabricating values.
4. Historical series retain their configured capacity and chronological ordering.
5. UI, menu, theme, and window state changes remain on the appropriate macOS application isolation boundary.

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
