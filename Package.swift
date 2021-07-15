// swift-tools-version:5.3

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
    .library(name: "MavsdkTests",
             targets: [
              "MavsdkTests"
             ]
    )
  ],
  dependencies: [
    .package(url: "https://github.com/grpc/grpc-swift", from: "1.0.0"),
    .package(url: "https://github.com/ReactiveX/RxSwift.git", from: "5.1.1"),
    .package(url: "https://github.com/byuarus/MAVSDK-XCFramework", .exact("0.40.0-gac872140"))
  ],
  targets: [
    .target(name: "Mavsdk",
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
              .product(name: "mavsdk_server",
                       package: "MAVSDK-XCFramework",
                       condition: .when(platforms: [.iOS, .macOS]))
            ]
    ),
    .testTarget(name: "MavsdkTests",
                dependencies: [
                  "Mavsdk",
                  .product(name: "RxTest", package: "RxSwift"),
                  .product(name: "RxBlocking", package: "RxSwift")
                ]
    )
  ]
)
