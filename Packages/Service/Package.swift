// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Service",
  platforms: [
    .iOS(.v15),
    .macOS(.v13)
  ],
  products: [
    // Products define the executables and libraries a package produces, making them visible to other packages.
    .library(
      name: "Service",
      targets: ["Service"]),
  ],
  dependencies: [
    .package(path: "../Shared"),
    .package(url: "https://github.com/tgrapperon/swift-dependencies-additions.git", from: "1.0.2"),
  ],
  targets: [
    // Targets are the basic building blocks of a package, defining a module or a test suite.
    // Targets can depend on other targets in this package and products from dependencies.
    .target(
      name: "Service", dependencies: [
        .product(name: "ThirdPartyKit", package: "Shared"),
        .product(name: "DependenciesAdditions", package: "swift-dependencies-additions"),
      ]),
  ])
