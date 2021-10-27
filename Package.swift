// swift-tools-version:5.4
import PackageDescription

let package = Package(
  name: "Mavsdk",
  platforms: [
    .iOS(.v13),
    .macOS(.v10_15)
  ],
  products: [
    .library(name: "Mavsdk",
             targets: [
              "Mavsdk",
             ]
    ),
    .library(name: "MavsdkServer",
             targets: [
              "MavsdkServer"
             ]
    ),
    .library(name: "mavsdk_server",
             targets: [
              "mavsdk_server"
             ]
    )
  ],
  dependencies: [
    .package(url: "https://github.com/grpc/grpc-swift", from: "1.0.0"),
    .package(url: "https://github.com/ReactiveX/RxSwift.git", from: "5.1.1")
  ],
  targets: [
    .target(name: "Mavsdk",
            dependencies: [
                .product(name: "GRPC", package: "grpc-swift"),
                .product(name: "RxSwift", package: "RxSwift"),
                .product(name: "RxBlocking", package: "RxSwift")
            ],
            exclude: [
              "proto",
              "templates",
              "tools"
            ]
    ),
    .target(name: "MavsdkServer",
            dependencies: [
                "mavsdk_server"
            ]
    ),
    .binaryTarget(name: "mavsdk_server",
                      url: "https://github.com/byuarus/MAVSDK-XCFramework/releases/download/0.45.0-oct27/mavsdk_server.xcframework.zip",
                      checksum: "6b4dc062a7e377db5c1e87b14a66dbdb47e4b8a59eec362f22b14f43c159c77f"),
    .testTarget(name: "MavsdkTests",
                dependencies: [
                  "Mavsdk",
                  .product(name: "RxTest", package: "RxSwift"),
                  .product(name: "RxBlocking", package: "RxSwift")
                ]
    )
  ]
)
