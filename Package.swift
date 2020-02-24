// swift-tools-version:5.1

import PackageDescription

let package = Package(
  name: "SVG",
  platforms: [
    .iOS(.v10),
    .macOS(.v10_13)
  ],
  products: [
    .library(name: "SVG", targets: ["SVG"]),
  ],
  targets: [
    .target(name: "SVG")
  ]
)
