// swift-tools-version:5.1
import PackageDescription

let package = Package(
  name: "MAVSDK-Swift",
  platforms: [.iOS("13.5")],
  products: [
    .library(name: "MAVSDK_Swift", type: .dynamic, targets: ["MAVSDK-Swift"])
  ],
  dependencies: [
    //.package(url: "https://github.com/grpc/grpc-swift", .branch("1.0.0-alpha.16")),
    .package(url: "https://github.com/jonasvautherin/grpc-swift", .branch("hardcode-ios-target")),
    .package(url: "https://github.com/ReactiveX/RxSwift.git", "5.0.0" ..< "6.0.0")
  ],
  targets: [
    .target(name: "MAVSDK-Swift",
            dependencies: ["GRPC", "RxSwift"])
  ]
)
