# MAVSDK-Swift

## Getting started in iOS

### Carthage

Firstly, make sure you have [RubyGems](https://rubygems.org/pages/download) installed, then install the xcodeproj gem:

```
gem install --user xcodeproj
```

Add the following to your `Cartfile`:

```shell
github "mavlink/MAVSDK-Swift" ~> 0.8.0
```

Add the following to your `.gitignore`:

```shell
/Carthage
```

And then get the framework using:

```shell
carthage bootstrap --platform ios
```

Back in your Xcode project you will need to import some libraries. On your application targets’ General settings tab, in the “Linked Frameworks and Libraries” section, drag and drop all files with the file extension `.framework` under the new `/Carthage/Build/iOS/` folder in your project into here, except for `RxBlocking.framework`, `RxCocoa.framework`, and `RxTest.framework`.

On your application targets’ Build Phases settings tab, click the + icon and choose New Run Script Phase. Create a Run Script in which you specify your shell (ex: /bin/sh), add the following contents to the script area below the shell:
```
/usr/local/bin/carthage copy-frameworks
```
Add the paths to the frameworks under “Input Files".
```
$(SRCROOT)/Carthage/Build/iOS/BoringSSL.framework
$(SRCROOT)/Carthage/Build/iOS/CgRPC.framework
$(SRCROOT)/Carthage/Build/iOS/mavsdk_server.framework
$(SRCROOT)/Carthage/Build/iOS/MAVSDK_Swift.framework
$(SRCROOT)/Carthage/Build/iOS/RxSwift.framework
$(SRCROOT)/Carthage/Build/iOS/SwiftProtobuf.framework
$(SRCROOT)/Carthage/Build/iOS/SwiftGRPC.framework
```
Add the paths to the copied frameworks to the “Output Files”.
```
$(DERIVED_FILE_DIR)/$(FRAMEWORKS_FOLDER_PATH)/BoringSSL.framework
$(DERIVED_FILE_DIR)/$(FRAMEWORKS_FOLDER_PATH)/CgRPC.framework
$(DERIVED_FILE_DIR)/$(FRAMEWORKS_FOLDER_PATH)/mavsdk_server.framework
$(DERIVED_FILE_DIR)/$(FRAMEWORKS_FOLDER_PATH)/MAVSDK_Swift.framework
$(DERIVED_FILE_DIR)/$(FRAMEWORKS_FOLDER_PATH)/RxSwift.framework
$(DERIVED_FILE_DIR)/$(FRAMEWORKS_FOLDER_PATH)/SwiftProtobuf.framework
$(DERIVED_FILE_DIR)/$(FRAMEWORKS_FOLDER_PATH)/SwiftGRPC.framework
```

Lastly, you will then need to go into `Build Settings`, click on `All`, then search for bitcode. You need to change `Enable Bitcode` from "Yes" to "No".

#### Troubleshooting
If you run into any issues with running the carthage command then you can clear the cache and try it again
```
rm -rf Carthage ~/Library/Caches/org.carthage.CarthageKit ~/Library/Caches/carthage
```

### Start MAVLink connection

The steps below assume that your iOS device has a network connection to the drone, e.g. using WiFi.

By default, the SDK will connect using MAVLink on UDP port 14540, which is running by default when PX4 is run in SITL (software in the loop simulation).
For now, the backend is limited to UDP even though the core supports UDP, TCP, and serial.

```swift
import MAVSDK_Swift

let drone = Drone()
drone.startMavlink.subscribe()
```

After that, you can start writing some code [as described below](#start-writing-code).

__For advanced users:__ note that `startMavlink` will run the SDK backend in a background thread on the iOS device. You could connect the SDK to another backend (say, running on a computer with IP `192.168.0.42` by omitting the second line above and running only: `let drone = Drone(address: "192.168.0.42", port: 50051)`.

If you're using a wifi bridge then you can start a UDP connection with the following:
```swift
drone.setMavlinkPort(mavlinkPort: "udp://:14550")
```

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

Check out the [examples](https://github.com/mavlink/MAVSDK-Swift-Example) for more examples using this framework.

## Contribute

If you want to contribute, please check out: [CONTRIBUTING.md](https://github.com/mavlink/MAVSDK-Swift/blob/master/CONTRIBUTING.md).

### Build the SDK

Most of the SDK is auto-generated from the proto files (see in _proto/protos_). Note that they come from a submodule (i.e. you may need to `$ git submodule update --init --recursive`).

Prior to building the SDK you will need to install the following packages via `brew` if you don't already have them.

```shell
brew install xcodegen protobuf
```

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

This will create the `MAVSDK-Swift.xcodeproj` project file from `project.yml`. 
