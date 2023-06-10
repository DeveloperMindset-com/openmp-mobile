// swift-tools-version:5.5
import PackageDescription
 
let package = Package(
    name: "OpenMP",
    platforms: [
        .macOS(.v13_3), .iOS(.v13), .watchOS(.v6_0)
    ],
    products: [
        .library(
            name: "OpenMP",
            targets: ["OpenMP"]),
    ],
    dependencies: [
    ],
    targets: [
        .binaryTarget(
            name: "OpenMP",
            url: “https://url/to/remote/OpenMP.xcframework.zip",
            checksum: "954f92b2894168cd2e6f04010caa41aa894f337a9a01a7b1f7720a73845e274e"
        )
    ]
)