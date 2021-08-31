// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "FormStateKit",
    products: [
        .library(name: "FormStateKit", targets: ["FormStateKit"]),
    ],
    targets: [
        .target(
            name: "FormStateKit",
            dependencies: []),
        .testTarget(
            name: "FormStateKitTests",
            dependencies: ["FormStateKit"]),
    ]
)
