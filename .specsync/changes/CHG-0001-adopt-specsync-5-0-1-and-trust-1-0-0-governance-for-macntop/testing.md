---
change: CHG-0001-adopt-specsync-5-0-1-and-trust-1-0-0-governance-for-macntop
artifact: testing
---

# Testing

- `specsync check --strict --require-coverage 100 --force` must report all 38 authored Swift files plus complete LOC and export coverage.
- `REQ-macntop-001`: CPU and memory model and monitor tests plus the non-networked lane verify local sampling.
- `REQ-macntop-002`: network and disk tests verify aggregation, first samples, counters, and volumes.
- `REQ-macntop-003`: process, GPU, power, thermal, and system service tests verify supported and unavailable states.
- `REQ-macntop-004`: coordinator tests verify snapshot refresh, history, and partial availability.
- `REQ-macntop-005`: history tests verify ordering, capacity, clearing, and summaries.
- `REQ-macntop-006`: formatter and model tests verify units, rates, percentages, temperatures, and unavailable values.
- `REQ-macntop-007`: menu-bar controller and icon renderer tests plus the macOS build verify application entry behavior.
- `REQ-macntop-008`: dashboard controller and window tests verify visibility, placement, and notifications.
- `REQ-macntop-009`: view tests and source-boundary review verify model-only rendering.
- `REQ-macntop-010`: sparkline, CRT, theme, and application-state tests verify presentation preferences.
- `REQ-macntop-011`: Swift 6 build and the full suite verify actor, `Sendable`, and main-application isolation.
- `REQ-macntop-012`: the Fledge lane runs only `swift build` and `swift test`; it does not launch, deploy, or publish.
- `specsync agents status` must report Claude, Cursor, Codex, and Gemini installed.
- `fledge trust doctor`, `swift build`, `swift test`, and `fledge trust verify` must pass.
- Verification must not launch the interactive app, transmit metrics, deploy, or publish a release; exact-head hosted checks remain a merge gate rather than a pre-verification claim.
