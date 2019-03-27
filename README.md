# Dronecode-SDK-Swift

## Getting started in iOS

### Carthage

Firstly, make sure you have [RubyGems](https://rubygems.org/pages/download) installed, then install the xcodeproj gem:

```
gem install --user xcodeproj
```

Add the following to your `Cartfile`:

```shell
github "Dronecode/DronecodeSDK-Swift" ~> 0.3.0
```

And then get the framework using:

```shell
carthage bootstrap --platform ios
```

### Start MAVLink connection

The steps below assume that your iOS device has a network connection to the drone, e.g. using WiFi.

By default, the SDK will connect using MAVLink on UDP port 14540, which is running by default when PX4 is run in SITL (software in the loop simulation).
For now, the backend is limited to UDP even though the core supports UDP, TCP, and serial.

```swift
import Dronecode_SDK_Swift

let drone = Drone()
drone.startMavlink.subscribe()
```

After that, you can start writing some code [as described below](#start-writing-code).

__For advanced users:__ note that `startMavlink` will run the SDK backend in a background thread on the iOS device. You could connect the SDK to another backend (say, running on a computer with IP `192.168.0.42` by omitting the second line above and running only: `let drone = Drone(address: "192.168.0.42", port: 50051)`.

## Start writing code
After that, you can start using the SDK, for instance:

```swift
drone.action.arm()
     .andThen(drone.action.takeoff())
     .subscribe()
```

or

```swift
drone.telemetry.position()
     .do(onNext: { next in print(next) })
     .subscribe()
```

Learn more about RxSwift [here](https://github.com/ReactiveX/RxSwift), and have a look at our [examples](#examples).

### Examples

Check out the [examples](https://github.com/Dronecode/DronecodeSDK-Swift-Example) for more examples using this framework.

## Contribute

If you want to contribute, please check out: [CONTRIBUTING.md](https://github.com/Dronecode/DronecodeSDK-Swift/blob/master/CONTRIBUTING.md).

### Build the SDK

Most of the SDK is auto-generated from the proto files (see in _proto/protos_). Note that they come from a submodule (i.e. you may need to `$ git submodule update --init --recursive`).

To generate the source code, run:

```shell
bash tools/generate_from_protos.bash
```

After that, you can either build the code with SwiftPM using:

```shell
swift build
```

Or generate an iOS Xcode project with:

```shell
xcodegen
```

This will create the `Dronecode-SDK-Swift.xcodeproj` project file from `project.yml`. If you don't have it already, install Xcodegen with:

```shell
brew install xcodegen
```
