// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "FormStateKit",
    platforms: [.iOS(.v13), .tvOS(.v13), .watchOS(.v6), .macOS(.v10_15)],
    products: [
        .library(name: "FormStateKit", targets: ["FormStateKit"])
    ],
    targets: [
        .target(
            name: "FormStateKit",
            dependencies: []
        ),
        .testTarget(
            name: "FormStateKitTests",
            dependencies: ["FormStateKit"]
        )
    ]
)
