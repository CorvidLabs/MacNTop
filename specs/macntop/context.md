---
spec: macntop.spec.md
---

## Context

MacNTop is a macOS-only pre-1.0 executable using restricted local system APIs, actor-based monitoring, native AppKit/SwiftUI presentation, and a single macOS CI workflow.

## Related Modules

- AppState provides existing application preference state.

## Design Decisions

- Preserve macOS-only runner and local privacy boundary.
- Verify build and tests without launching the menu-bar application.
