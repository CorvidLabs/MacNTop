# Contributing to MacNTop

Thank you for your interest in contributing to MacNTop!

## Code Style

This project follows [CorvidLabs Swift Conventions](https://github.com/CorvidLabs). Key points:

### Must Follow

- **Explicit access control** - Add `public`/`internal`/`private` to ALL declarations
- **K&R brace style** - Opening brace on same line: `func foo() {`
- **No force unwrap** - Never use `!`, `try!`, or `as!`
- **async/await** - No completion handlers
- **Sendable conformance** - All types crossing concurrency boundaries

### Formatting

- 4 spaces for indentation (no tabs)
- 120 character line limit
- MARK sections: `// MARK: - Section Name`

### Documentation

All public APIs must have documentation:

```swift
/// Brief description.
/// - Parameter key: The identifier.
/// - Returns: The value, or nil if not found.
public func get(_ key: Key) -> Value?
```

## Development Workflow

### Setup

```bash
git clone https://github.com/CorvidLabs/MacNTop.git
cd MacNTop
swift build
```

### Making Changes

1. Create a feature branch: `git checkout -b feature/my-feature`
2. Make your changes
3. Ensure the build passes: `swift build`
4. Commit with a clear message: `git commit -m "Add: new feature"`

### Commit Message Format

```
Add: new feature
Fix: bug description
Update: existing feature
Remove: deleted functionality
Refactor: code restructuring
Docs: documentation changes
```

### Pull Request

1. Push your branch: `git push origin feature/my-feature`
2. Open a Pull Request against `main`
3. Fill out the PR template
4. Wait for CI to pass
5. Request review

## Architecture Guidelines

### Actors for Monitors

All monitoring services should be actors:

```swift
public actor MyMonitor {
    public func collectMetrics() async -> MyMetrics {
        // Thread-safe collection
    }
}
```

### Sendable Models

All data models must be Sendable:

```swift
public struct MyMetrics: Sendable {
    public let value: Double
    public let timestamp: Date
}
```

### Views

Views use AppKit and should:
- Use `RetroTheme` for colors
- Support theme changes via notification
- Follow the existing pattern in other views

## Testing

```bash
swift test
```

## Questions?

Open an issue or start a discussion on GitHub.
