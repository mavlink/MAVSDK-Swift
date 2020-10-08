// swift-tools-version:5.3
import PackageDescription

let package = Package(
  name: "MavsdkServer",
  platforms: [
    .iOS(.v8)
  ],
  products: [
    .library(name: "MavsdkServer", targets: ["MavsdkServer"])
  ],
  dependencies: [
    .package(url: "https://github.com/ReactiveX/RxSwift.git", from: "5.0.0"),
  ],
  targets: [
    .target(name: "MavsdkServer", 
            dependencies: [ 
              "RxSwift", 
              "MavsdkServerCpp" 
            ] 
    ),
    .binaryTarget(name: "MavsdkServerCpp",
                  path: "mavsdk_server.xcframework"
    )
//    .binaryTarget(name: "MavsdkServer",
//                  url: "https://github.com/mavlink/MAVSDK/releases/download/v0.31.0/mavsdk_server_ios.zip",
//                  checksum: "075be332f9849752e0f2b3e8d35e70ebcca39d8813f0c4e44810cf5967c3ad78"
//    )
  ]
)
