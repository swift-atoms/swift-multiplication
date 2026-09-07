// swift-tools-version: 6.4
import PackageDescription

let package = Package(
    name: "swift-multiplication",
    platforms: [.macOS(.v27), .iOS(.v27), .tvOS(.v27), .watchOS(.v27), .visionOS(.v27)],
    products: [
        .library(name: "Multiplication", targets: ["Multiplication"]),

        .library(name: "Multiplication Foundation Integration", targets: ["Multiplication Foundation Integration"]),
        .library(name: "Multiplication Test Support", targets: ["Multiplication Test Support"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-atoms/swift-polarity.git",
            branch: "main"
        ),
    ],
    targets: [
        .target(
            name: "Multiplication",
            dependencies: [
                .product(name: "Polarity", package: "swift-polarity"),
            ],
            path: "Sources/Multiplication"
        ),
        
        .target(
            name: "Multiplication Foundation Integration",
            dependencies: [
                .target(name: "Multiplication"),
            ],
            path: "Sources/Multiplication Foundation Integration"
        ),
        .target(
            name: "Multiplication Test Support",
            dependencies: [
                .target(name: "Multiplication"),
            ],
            path: "Tests/Support"
        ),
        .testTarget(
            name: "Multiplication Tests",
            dependencies: [
                .target(name: "Multiplication"),
                .product(name: "Polarity", package: "swift-polarity"),
                .target(name: "Multiplication Test Support"),
                .target(name: "Multiplication Foundation Integration"),
            ],
            path: "Tests/Multiplication Tests"
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets {
    target.swiftSettings = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]
}
