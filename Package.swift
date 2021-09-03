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
                      url: "https://github.com/Esri/MAVSDK-Swift/releases/download/0.43.0-test2/mavsdk_server.xcframework.zip",
                      checksum: "fed1e8fed3b3feca8f8232e6120519a2ffe3e5fcedd14cbb373023498852daf2"),
    .testTarget(name: "MavsdkTests",
                dependencies: [
                  "Mavsdk",
                  .product(name: "RxTest", package: "RxSwift"),
                  .product(name: "RxBlocking", package: "RxSwift")
                ]
    )
  ]
)
