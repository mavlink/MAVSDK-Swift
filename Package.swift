// swift-tools-version:5.3

import PackageDescription

let package = Package(
  name: "MAVSDK_Swift",
  products: [
    .library(name: "MAVSDK_Swift",
             targets: [
              "MAVSDK-Swift",
             ]
    ),
    .library(name: "MavsdkServer",
             targets: [
              "MavsdkServer"
             ]
    )
  ],
  dependencies: [
    .package(url: "https://github.com/grpc/grpc-swift", from: "1.0.0-alpha.20"),
    .package(url: "https://github.com/ReactiveX/RxSwift.git", from: "5.1.1"),
  ],
  targets: [
    .target(name: "MAVSDK-Swift",
            dependencies: [
              .product(name: "GRPC", package: "grpc-swift"),
              .product(name: "RxSwift", package: "RxSwift")
            ],
            exclude: [
              "proto",
              "templates",
              "tools"
            ]
    ),
    .target(name: "MavsdkServer",
            dependencies: [
              .product(name: "RxSwift", package: "RxSwift"),
              "mavsdk_server"
            ]
    ),
    .binaryTarget(name: "mavsdk_server",
                  url: "https://github.com/mavlink/MAVSDK/releases/download/v0.35.1/mavsdk_server.xcframework.zip",
                  checksum: "b66200120286445bb3e63d74de8250cff2c8c3562a27ad64c555d7d5f9eee285"),
    .testTarget(name: "MAVSDK-SwiftTests",
                dependencies: [
                  "MAVSDK-Swift",
                  "MavsdkServer",
                  .product(name: "RxTest", package: "RxSwift"),
                  .product(name: "RxBlocking", package: "RxSwift")
                ]
    )
  ]
)
