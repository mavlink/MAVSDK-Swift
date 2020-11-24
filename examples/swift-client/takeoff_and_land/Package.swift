// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "takeoff_and_land",
    dependencies: [
        .package(name: "MAVSDK_Swift", path: "../../.."),
    ],
    targets: [
        .target(
            name: "takeoff_and_land",
            dependencies: [
                .product(name: "MAVSDK_Swift", package: "MAVSDK_Swift"),
                .product(name: "MavsdkServer", package: "MAVSDK_Swift")
            ]
	)
    ]
)
