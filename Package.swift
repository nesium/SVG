// swift-tools-version:5.1

import PackageDescription

let package = Package(
  name: "SVG",
  platforms: [
    .iOS(.v11),
    .macOS(.v10_13)
  ],
  products: [
    .library(name: "SVG", targets: ["SVG"]),
  ],
  dependencies: [
//    .package(url: "https://github.com/pointfreeco/swift-snapshot-testing.git", from: "1.5.0")
  ],
  targets: [
    .target(name: "SVG", dependencies: []),
//    .testTarget(name: "SVGTests", dependencies: ["SVG", "SnapshotTesting"])
  ]
)
