// swift-tools-version:5.2
import PackageDescription

let package = Package(
  name: "MAVSDK-Swift",
  //platforms: [.iOS("13.5")],
  products: [
    .library(name: "MAVSDK_Swift", type: .dynamic, targets: ["MAVSDK-Swift"])
  ],
  dependencies: [
    .package(url: "https://github.com/grpc/grpc-swift", .branch("1.0.0-alpha.20")),
    //.package(url: "https://github.com/jonasvautherin/grpc-swift", .branch("hardcode-ios-target")),
    .package(url: "https://github.com/ReactiveX/RxSwift.git", from: "5.0.0")
  ],
  targets: [
    .target(name: "MAVSDK-Swift",
            dependencies: [
              .product(name: "GRPC", package: "grpc-swift"),
              "RxSwift"
            ]
/*,
            swiftSettings: [
              .unsafeFlags(["-FFrameworks/Build/iOS"]),
            ],
            linkerSettings: [
              .linkedFramework("mavsdk_server")
            ]
*/
    )
  ]
)
