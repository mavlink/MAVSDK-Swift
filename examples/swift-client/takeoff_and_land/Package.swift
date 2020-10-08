// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "takeoff_and_land",
    dependencies: [
        .package(name: "MAVSDK-Swift", path: "../../../sdk"),
    ],
    targets: [
        .target(
            name: "takeoff_and_land",
            dependencies: [
                .product(name: "MAVSDK_Swift", package: "MAVSDK-Swift")
            ]
	)
    ]
)
