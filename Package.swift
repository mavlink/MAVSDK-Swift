// swift-tools-version:4.2
import PackageDescription

let package = Package(
  name: "Dronecode-SDK-Swift",
  products: [
    .library(name: "Dronecode_SDK_Swift", type: .dynamic, targets: ["Dronecode-SDK-Swift"])
  ],
  dependencies: [
    .package(url: "https://github.com/grpc/grpc-swift", .exact("0.6.0")),
    .package(url: "https://github.com/ReactiveX/RxSwift.git", "4.0.0" ..< "5.0.0")
  ],
  targets: [
    .target(name: "Dronecode-SDK-Swift",
            dependencies: ["SwiftGRPC", "RxSwift"])
  ]
)
