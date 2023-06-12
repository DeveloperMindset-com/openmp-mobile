// swift-tools-version:5.5
import PackageDescription
 
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
            url: “https://github.com/eugenehp/openmp-mobile/releases/download/15.0.6/openmp.xcframework.zip",
            checksum: "fefbe79b60262dc5400b31d9d06e112f223f2cac9c703b82e474a49557645db7"
        )
    ]
)