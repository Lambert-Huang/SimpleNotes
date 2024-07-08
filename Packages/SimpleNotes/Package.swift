// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "SimpleNotes",
  platforms: [
    .iOS(.v15),
    .macOS(.v13)
  ],
  products: [
    // Products define the executables and libraries a package produces, making them visible to other packages.
    .library(
      name: "AppFeature",
      targets: ["AppFeature"]
    ),
    .library(
      name: "BaseFeature",
      targets: ["BaseFeature"]
    ),
    .library(
      name: "UIFeatureKit",
      targets: ["UIFeatureKit"]
    ),
		.library(
			name: "OnboardingFeature",
			targets: ["OnboardingFeature"]
		),
		.library(
			name: "HomeFeature",
			targets: ["HomeFeature"]
		),
		.library(
			name: "RootTabFeature",
			targets: ["RootTabFeature"]
		),
  ],
  dependencies: [
    .package(path: "../Shared"),
    .package(path: "../Service"),
    .package(path: "../UI"),
  ],
  targets: [
    // Targets are the basic building blocks of a package, defining a module or a test suite.
    // Targets can depend on other targets in this package and products from dependencies.
    .target(
      name: "AppFeature",
      dependencies: [
        "UIFeatureKit",
				"RootTabFeature",
				"OnboardingFeature",
      ],
      resources: [
        .process("Resources")
      ]
    ),
		.target(
			name: "HomeFeature",
			dependencies: [
				"UIFeatureKit",
			],
			resources: [
				.process("Resources")
			]
		),
		.target(
			name: "RootTabFeature",
			dependencies: [
				"UIFeatureKit",
			],
			resources: [
				.process("Resources")
			]
		),
		.target(
			name: "OnboardingFeature",
			dependencies: [
				"UIFeatureKit",
			],
			resources: [
				.process("Resources")
			]
		),
    .target(
      name: "BaseFeature",
      dependencies: [
//        .product(name: "Storage", package: "Service"),
        .product(name: "ThirdPartyKit", package: "Shared"),
        .product(name: "ImageResourceKit", package: "Shared"),
        .product(name: "UIDesignKit", package: "UI"),
      ]
    ),
    .target(
      name: "UIFeatureKit",
      dependencies: [
        "BaseFeature",
        .product(name: "ThirdPartyKit", package: "Shared")
      ]
    ),
  ]
)
