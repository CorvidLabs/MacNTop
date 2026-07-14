---
change: CHG-0001-adopt-specsync-5-0-1-and-trust-1-0-0-governance-for-macntop
artifact: context
---

# Context

MacNTop is a local-only macOS 14 system monitor with 38 authored Swift files. Actor-based services sample restricted system APIs into `Sendable` models; a coordinator maintains bounded history; AppKit views, menu-bar controllers, themes, and formatting render that state. The migration must describe those existing boundaries completely without launching the app or changing product bytes.
