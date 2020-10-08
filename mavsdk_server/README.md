# MavsdkServer

This is an SPM package exposing `mavsdk_server`, against which MAVSDK-Swift can connect.

## Installation

TBD

## Build

The project can be opened with Xcode and built directly.

Note that it only supports iOS (i.e. the `mavsdk_server` frameworks are binaries built for iOS and the iOS Simulator).
Therefore, building from command line will not work with the `swift build` command, but can be done with `xcodebuild`:

First list the destinations:

```
// List the destinations and schemes
xcodebuild -showdestinations
```

Then pick a destination and run the build accordingly, for instance:

```
xcodebuild -scheme MavsdkServer -destination 'platform=iOS Simulator,OS=14.0,name=iPad (8th generation)'
```
