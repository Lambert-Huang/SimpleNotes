// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "UI",
  platforms: [
    .iOS(.v15),
    .macOS(.v13),
  ],
  products: [
    // Products define the executables and libraries a package produces, making them visible to other packages.
    .library(
      name: "UIDesignKit",
      targets: ["UIDesignKit"]),
  ],
  dependencies: [
    .package(path: "../Shared"),
    .package(path: "../Service"),
    .package(url: "https://github.com/airbnb/lottie-spm.git", .upToNextMajor(from: "4.4.3")),
  ],
  targets: [
    // Targets are the basic building blocks of a package, defining a module or a test suite.
    // Targets can depend on other targets in this package and products from dependencies.
    .target(
      name: "UIDesignKit",
      dependencies: [
				.product(name: "Entity", package: "Service"),
        .product(name: "DesignKit", package: "Shared"),
        .product(name: "ThirdPartyKit", package: "Shared"),
        .product(name: "ImageResourceKit", package: "Shared"),
        .product(name: "Lottie", package: "lottie-spm"),
      ],
      resources: [.process("Resources")]
    ),
  ]
)
