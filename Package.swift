// swift-tools-version:5.5
import PackageDescription

let version = "16.0.5"
let checksum = "958970064322013ff4fa92ecb0ba53cea4eb3fce41be29498eb645e531f4fe6d"
 
let package = Package(
    name: "OpenMP",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6)
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
            url: "https://github.com/DeveloperMindset-com/openmp-mobile/releases/download/v\(version)/openmp.xcframework.zip",
            checksum: checksum
        )
    ]
)