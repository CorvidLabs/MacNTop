import AppKit

/// Controls the status bar item and popover.
@MainActor
public final class StatusBarController {
    // MARK: - Properties

    private var statusItem: NSStatusItem?
    private var popover: NSPopover?
    private let iconRenderer = StatusBarIconRenderer()

    private var dashboardViewController: DashboardViewController?
    private var dashboardWindow: DashboardWindow?
    private var eventMonitor: Any?

    // MARK: - Initialization

    public init() {
        observeNotifications()
    }

    private func observeNotifications() {
        NotificationCenter.default.addObserver(
            forName: .themeChanged,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            Task { @MainActor in
                self?.recreatePopover()
            }
        }

        NotificationCenter.default.addObserver(
            forName: .dashboardWindowClosed,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            Task { @MainActor in
                self?.dashboardWindow = nil
            }
        }
    }

    private func recreatePopover() {
        let wasShown = popover?.isShown == true
        popover?.close()
        setupPopover()
        if wasShown {
            showPopover()
        }
    }

    // MARK: - Public Methods

    /// Sets up the status bar item.
    public func setup() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        guard let button = statusItem?.button else {
            print("ERROR: Could not get status item button")
            return
        }

        if let image = NSImage(systemSymbolName: "cpu", accessibilityDescription: "MacNTop") {
            button.image = image
        } else {
            button.title = "MNT"
        }
        button.action = #selector(togglePopover(_:))
        button.target = self
        button.sendAction(on: [.leftMouseUp, .rightMouseUp])

        print("Status bar setup complete")
        setupPopover()
        setupEventMonitor()
    }

    /// Updates the status bar icon with current metrics.
    public func updateIcon(cpuUsage: Double, memoryUsage: Double) {
        guard let button = statusItem?.button else { return }

        let cpu = Int(cpuUsage.rounded())
        let mem = Int(memoryUsage.rounded())
        button.title = " C:\(cpu)% M:\(mem)%"
        button.toolTip = "CPU: \(cpu)%  Memory: \(mem)%"
    }

    /// Updates the dashboard with new metrics.
    public func updateDashboard(with snapshot: MetricsSnapshot, systemInfo: SystemInfo) {
        dashboardViewController?.updateMetrics(snapshot: snapshot, systemInfo: systemInfo)
        dashboardWindow?.updateMetrics(snapshot: snapshot, systemInfo: systemInfo)
    }

    /// Opens the dashboard in a standalone window.
    public func openWindow() {
        if dashboardWindow == nil {
            dashboardWindow = DashboardWindow()
        }
        dashboardWindow?.showWindow()
        hidePopover()
    }

    /// Closes the dashboard window.
    public func closeWindow() {
        dashboardWindow?.close()
        dashboardWindow = nil
    }

    /// Returns whether the dashboard window is currently open.
    public var isWindowOpen: Bool {
        dashboardWindow?.isVisible == true
    }

    /// Shows the popover.
    public func showPopover() {
        guard let button = statusItem?.button, let popover = popover else { return }

        if !popover.isShown {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            NSApp.activate(ignoringOtherApps: true)
        }
    }

    /// Hides the popover.
    public func hidePopover() {
        popover?.close()
    }

    /// Cleans up resources.
    public func cleanup() {
        if let monitor = eventMonitor {
            NSEvent.removeMonitor(monitor)
            eventMonitor = nil
        }
        dashboardWindow?.close()
        dashboardWindow = nil
        statusItem = nil
        popover = nil
    }

    // MARK: - Private Methods

    private func setupPopover() {
        popover = NSPopover()
        popover?.behavior = .transient
        popover?.animates = true

        dashboardViewController = DashboardViewController()
        popover?.contentViewController = dashboardViewController
        popover?.contentSize = NSSize(width: 480, height: 720)
    }

    private func setupEventMonitor() {
        eventMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDown, .rightMouseDown]) { [weak self] _ in
            if self?.popover?.isShown == true {
                self?.hidePopover()
            }
        }
    }

    @objc
    private func togglePopover(_ sender: NSStatusBarButton) {
        guard let event = NSApp.currentEvent else { return }

        if event.type == .rightMouseUp {
            showContextMenu(from: sender)
        } else {
            if popover?.isShown == true {
                hidePopover()
            } else {
                showPopover()
            }
        }
    }

    private func showContextMenu(from button: NSStatusBarButton) {
        let menu = NSMenu()

        // Window mode toggle
        if isWindowOpen {
            menu.addItem(NSMenuItem(title: "Close Window", action: #selector(toggleWindowMode), keyEquivalent: "w"))
        } else {
            menu.addItem(NSMenuItem(title: "Open in Window", action: #selector(toggleWindowMode), keyEquivalent: "w"))
        }

        menu.addItem(NSMenuItem.separator())

        // Theme submenu
        let themeMenu = NSMenu()
        let currentTheme = AppTheme.current
        for theme in Themes.all {
            let item = NSMenuItem(title: theme.name, action: #selector(selectTheme(_:)), keyEquivalent: "")
            item.target = self
            item.representedObject = theme
            if theme.name == currentTheme.name {
                item.state = .on
            }
            themeMenu.addItem(item)
        }
        let themeMenuItem = NSMenuItem(title: "Theme", action: nil, keyEquivalent: "")
        themeMenuItem.submenu = themeMenu
        menu.addItem(themeMenuItem)

        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "About MacNTop", action: #selector(showAbout), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit MacNTop", action: #selector(quitApp), keyEquivalent: "q"))

        for item in menu.items where item.action != nil {
            item.target = self
        }

        statusItem?.menu = menu
        button.performClick(nil)
        statusItem?.menu = nil
    }

    @objc
    private func selectTheme(_ sender: NSMenuItem) {
        guard let theme = sender.representedObject as? ThemeColors else { return }
        AppTheme.setTheme(theme)
    }

    @objc
    private func toggleWindowMode() {
        if isWindowOpen {
            closeWindow()
        } else {
            openWindow()
        }
    }

    @objc
    private func showAbout() {
        let alert = NSAlert()
        alert.messageText = "MacNTop"
        alert.informativeText = "A macOS menu bar system monitor.\n\nVersion 1.0"
        alert.alertStyle = .informational
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }

    @objc
    private func quitApp() {
        NSApp.terminate(nil)
    }
}
