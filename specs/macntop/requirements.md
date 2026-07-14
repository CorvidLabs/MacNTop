---
spec: macntop.spec.md
---

## Requirements

### REQ-macntop-001

CPU and memory monitors SHALL sample local utilization, core, pressure, swap, and capacity data into the existing `Sendable` metric models without transmitting it.

Acceptance Criteria
- Existing CPU and memory model and monitor tests pass, and the verification lane performs no network or publication command.

### REQ-macntop-002

Network and disk monitors SHALL report per-interface or per-volume state and aggregate throughput while preserving unavailable-counter and first-sample behavior.

Acceptance Criteria
- Existing network and disk model and monitor tests cover aggregation, first samples, volumes, and unavailable counters.

### REQ-macntop-003

Process, GPU, power, thermal, and system-information services SHALL expose only values available from the current Mac and SHALL degrade through their existing optional or safe fallback paths.

Acceptance Criteria
- Existing service and model tests pass for supported values and unavailable or fallback states.

### REQ-macntop-004

`MetricsCoordinator` SHALL isolate shared sampling state in its actor, refresh the complete snapshot on the existing cadence, and prevent one unavailable monitor from crashing unrelated collection.

Acceptance Criteria
- Coordinator tests pass for snapshot refresh, history updates, and partial monitor availability.

### REQ-macntop-005

`HistoricalData` SHALL retain samples in chronological order, enforce its configured capacity, and preserve its existing numeric summary behavior.

Acceptance Criteria
- Historical data tests pass for append order, capacity eviction, clearing, and numeric summaries.

### REQ-macntop-006

`ByteFormatter` and metric display helpers SHALL preserve the existing human-readable units, percentages, rates, temperatures, and unavailable-value presentation.

Acceptance Criteria
- Formatter and model-derived display tests pass for representative values and unavailable data.

### REQ-macntop-007

The status-bar controller and icon renderer SHALL preserve the existing menu-bar popover, dashboard toggle, current status rendering, and application lifecycle behavior.

Acceptance Criteria
- The macOS build and existing menu-bar controller and renderer tests pass without launching the app.

### REQ-macntop-008

The dashboard controller and window SHALL preserve floating-window placement, visibility, resizing, and notification behavior on the main application isolation boundary.

Acceptance Criteria
- Existing dashboard controller and window tests pass on the macOS runner.

### REQ-macntop-009

CPU, memory, network, disk, process, static-information, and system-status views SHALL render the supplied snapshot without directly collecting or transmitting metrics.

Acceptance Criteria
- Existing view tests and the macOS build pass, and source review confirms views consume supplied models rather than monitor actors.

### REQ-macntop-010

`SparklineView`, `CRTEffectView`, and the retro theme types SHALL preserve the existing bounded visual history, optional CRT treatment, palette selection, and theme persistence.

Acceptance Criteria
- Existing sparkline, CRT, theme, and application-state tests pass on the macOS runner.

### REQ-macntop-011

All monitor, model, coordinator, and UI concurrency boundaries SHALL preserve the existing actor, `Sendable`, and main-application isolation guarantees.

Acceptance Criteria
- Swift 6 compilation and the complete test suite pass with the repository's existing strict concurrency settings.

### REQ-macntop-012

Native verification SHALL build the macOS executable and pass its complete test suite without launching the interactive application, transmitting metrics, deploying, or publishing a release.

Acceptance Criteria
- `swift build` and `swift test` pass, while the verification lane contains no run, deploy, release, or publication step.

## Constraints

- macOS 14 and restricted system APIs remain required.

## Out of Scope

- Changing metrics, UI, APIs, privacy behavior, dependencies, distribution, or releases.
