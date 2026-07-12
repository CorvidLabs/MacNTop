---
spec: macntop.spec.md
---

## Requirements

- **REQ-macntop-001** (stable): Monitor services shall sample the existing local CPU, memory, network, disk, process, GPU, power, thermal, and system information surfaces without transmitting data.
- **REQ-macntop-002** (stable): Metrics coordination and history shall preserve actor isolation, bounded chronological data, and existing unavailable-metric behavior.
- **REQ-macntop-003** (stable): Menu-bar, dashboard, window, theme, and formatting behavior shall remain consistent with the existing macOS application contract.
- **REQ-macntop-004** (stable): Native verification shall build and test on macOS without launching the interactive application or publishing a release.

## Constraints

- macOS 14 and restricted system APIs remain required.

## Out of Scope

- Changing metrics, UI, APIs, privacy behavior, dependencies, distribution, or releases.
