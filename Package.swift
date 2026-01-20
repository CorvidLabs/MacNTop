// swift-tools-version:6.0

import PackageDescription

let package = Package(
    name: "MacNTop",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .executable(name: "MacNTop", targets: ["MacNTop"])
    ],
    dependencies: [
        .package(url: "https://github.com/0xLeif/AppState.git", from: "1.0.0")
    ],
    targets: [
        .executableTarget(
            name: "MacNTop",
            dependencies: [
                .product(name: "AppState", package: "AppState")
            ],
            path: "Sources/MacNTop",
            swiftSettings: [
                .swiftLanguageMode(.v6)
            ],
            linkerSettings: [
                .linkedFramework("AppKit"),
                .linkedFramework("IOKit"),
                .linkedFramework("Metal")
            ]
        ),
        .testTarget(
            name: "MacNTopTests",
            dependencies: ["MacNTop"],
            path: "Tests/MacNTopTests",
            swiftSettings: [
                .swiftLanguageMode(.v6)
            ]
        )
    ]
)
