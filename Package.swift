// swift-tools-version:5.5
import PackageDescription

let version = "16.0.5"
let checksum = "f67b6b15778ea27e9f1fc2c83977f03688f6d1905c4718eba62530e7ae5c3098"
 
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
            url: "https://github.com/eugenehp/openmp-mobile/releases/download/v\(version)/openmp.xcframework.zip"
            checksum: checksum
        )
    ]
)