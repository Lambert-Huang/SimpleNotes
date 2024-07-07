// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Shared",
  platforms: [
    .iOS(.v15),
    .macOS(.v13)
  ],
  products: [
    // Products define the executables and libraries a package produces, making them visible to other packages.
    .library(
      name: "ThirdPartyKit",
      targets: ["ThirdPartyKit"]),
    .library(name: "DesignKit", targets: ["DesignKit"]),
    .library(
      name: "ImageResourceKit",
      targets: ["ImageResourceKit"]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/malcommac/SwiftDate.git", from: "7.0.0"),
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "1.10.0"),
  ],
  targets: [
    .target(
      name: "DesignKit",
      dependencies: []
    ),
    .target(
      name: "ThirdPartyKit", dependencies: [
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        .product(name: "SwiftDate", package: "SwiftDate")
      ]),
    .target(name: "ImageResourceKit", dependencies: [], resources: [.process("Resources")]),
  ])
