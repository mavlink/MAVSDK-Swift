# MAVSDK

The official MAVSDK client for Swift. This cross-platform gRPC library communicates to MAVLink compatible systems using a plugin architecture.

## Installing

### Swift Package

Add the following to your Package.swift dependencies:
```
dependencies: [
     .package(url: "https://github.com/mavlink/Mavsdk", from: "0.12.0"),
],
```
And add each product within each target as needed (`MavsdkServer` may be optional):
```
targets: [
    .target(name: "MyTarget",
            dependencies: [
              .product(name: "Mavsdk", package: "Mavsdk"),
              .product(name: "MavsdkServer", package: "Mavsdk")
            ],
    ),
  ]
```

### Start MAVLink connection

The steps below assume that your iOS device has a network connection to the drone, such as WiFi.

By default, the SDK will connect using MAVLink on UDP port 14540 to match the default port of the PX4 SITL (software in the loop simulation) drone.

The backend is currently limited to UDP only, even though the core supports UDP, TCP, and serial.

```swift
import MavsdkServer
import Mavsdk

let port = mavsdkServer.run()
let drone = Drone(port: Int32(port))
```

After that, you can start writing some code [as described below](#start-writing-code).

__For advanced users:__ note that `mavsdkServer.run()` will run the SDK backend on a background thread on the iOS device. You could use `Drone(address:port:scheduler)` connect the SDK to another backend IP address and port (such as `192.168.0.42`) and running
```swift
let drone = Drone(address: "192.168.0.42", port: 50051)
```

## Start writing code
After that, you can start using the SDK, for instance:

```swift
_ = drone.action.arm()
     .subscribe(onCompleted: {
          drone.action.takeoff()
     }, onError: { error in
          print(error.localizedDescription)
     })
```

or

```swift
_ = drone.telemetry.position
     .subscribe(onNext: { position in
          print(position)
     }, onError: { error in
          print(error.localizedDescription)
     })
```

You can learn more about [RxSwift](https://github.com/ReactiveX/RxSwift), and check out [MAVSDK-Swift-Example](https://github.com/mavlink/MAVSDK-Swift-Example) for more information on using this framework.

## Contribute

Before contributing, it's a good idea to file an issue on GitHub to get feedback from the project maintainers.

### Build the SDK

MAVSDK functions are mainly generated from files in the _/proto_ submodule (see _Sources/Mavsdk/proto_). First, you may need to initialize any uninitialized and nested submodules.

```shell
git submodule update --init --recursive
```

Before building the SDK you may need to install the following packages via [Homebrew](https://brew.sh/).

```shell
brew install protobuf
```

You will also need to install the following [Python](https://www.python.org/) libraries for MAVSDK. The first two commands are optional, and the last is required.

```shell
python3 -m venv venv
source venv/bin/activate

pip3 install protoc-gen-mavsdk
```

Then, to generate the source code, run:

```shell
bash Sources/Mavsdk/tools/generate_from_protos.bash
```

**NOTE**: The following requires Xcode 12 and Swift 5.3.

With your current Xcode project open, you can then locally source `Mavsdk` to override the remote Swift Package into your project. Open a Finder window, drag-and-drop the `Mavsdk` directory within the top level of your .xcodeproj, then click `File > Swift Packages > Resolve Package Versions` to resolve the package dependencies.

**NOTE**: If you have Xcode 11 and Swift 5.2 or lower and require `MavsdkServer`, use these additional steps.

Move `MavsdkServer.swift` from within the Mavsdk package into your main project. Modify Package.swift to remove the following:
```
.library(name: "MavsdkServer",
   targets: [
      "mavsdk_server"
   ]
)
```

Next, using Finder, download, unzip and move the binary for the iOS MAVSDK server (`mavsdk_server.xcframework`) downloaded from [MAVSDK Releases](https://github.com/mavlink/MAVSDK/releases) into your projects root directory (or where other dependencies may be installed) and update `FRAMEWORK_SEARCH_PATHS` in the Target Build Settings accordingly to find it.

### Generate docs

**Note**: CI generates docs for the main branch and pushes them to a [s3 bucket](http://dronecode-sdk-swift.s3.eu-central-1.amazonaws.com/docs/index.html).

To test the doc generation locally, install [jazzy](https://github.com/realm/jazzy):

```
sudo gem install jazzy
```

Then, to generate the docs, run:
```
bash Sources/Mavsdk/tools/generate_docs.sh
```
