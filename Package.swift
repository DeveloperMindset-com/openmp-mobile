// swift-tools-version:5.5
import PackageDescription

let version = "16.0.5"
let checksum = "0388556e23288de9c3df9a1a8242b9415b7a8f91fab6fd2911576ba5e93f7838"
 
let package = Package(
    name: "OpenMP",
    platforms: [
        .macOS(.v13_3), .iOS(.v13), .watchOS(.v6_0), .tvOS(.v6_0)
    ],
    products: [
        .library(
            name: "OpenMP",
            targets: ["OpenMP"]),
    ],
    dependencies: [],
    targets: [
        .binaryTarget(
            name: "OpenMP",
            url: "https://github.com/eugenehp/openmp-mobile/releases/download/\(version)/openmp.xcframework.zip",
            checksum: checksum
        )
    ]
)