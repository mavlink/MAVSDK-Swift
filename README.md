# MAVSDK-Swift

## Installing

### Swift Package

Add the following to your Package.swift dependencies:
```
dependencies: [
     .package(url: "https://github.com/mavlink/MAVSDK-Swift", from: "1.0.0"),
],

```
And add each product within each target as needed (`MavsdkServer` may be optional):
```
targets: [
    .target(name: "MAVSDK-Swift",
            dependencies: [
              .product(name: "MAVSDK-Swift", package: "MAVSDK-Swift"),
              .product(name: "MavsdkServer", package: "MAVSDK-Swift")
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
import MAVSDK_Swift

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

MAVSDK functions are mainly generated from files in the _/proto_ submodule (see _Sources/MAVSDK-Swift/proto_). First, you may need to intialized any unitialized or nested submodules.
```
$ git submodule update --init --recursive
```

Prior to building the SDK you may need to install the following packages via [Homebrew](https://brew.sh/).

```shell
brew install protobuf
```

To generate the source code, run:

```shell
bash Sources/MAVSDK-Swift/tools/generate_from_protos.bash
```

After that, you can build the code with Swift Package Manager using:

```shell
swift build
```

### Generate docs

**Note**: The docs are generated in travis-ci for the master branch and pushed to a [s3 bucket](http://dronecode-sdk-swift.s3.eu-central-1.amazonaws.com/docs/index.html).

To test the doc generation locally, install [jazzy](https://github.com/realm/jazzy):

```
gem install jazzy
```

Then, to generate the docs, run:
```
bash Sources/MAVSDK-Swift/tools/generate_docs.sh
```
