# Building Dronecode-SDK-Swift

## Install dependencies

### Prebuilt

1. Download dependencies from [here](https://s3.eu-central-1.amazonaws.com/dronecode-sdk/dronecode-sdk-swift-deps-latest.zip).
2. Unzip `dronecode-sdk-swift-deps-latest.zip`
3. Open Dronecode-SDK-Swift.xcodeproj in Xcode
4. Copy frameworks in the `Frameworks` group of Dronecode-SDK-Swift in Xcode

### Build from sources

Dependencies (gRPC and RxSwift) can be built from sources with the following commands:

```
bash build_grpc.bash
bash build_rxswift.bash
```

## Build SDK framework

Dronecode-SDK-Swift depends on gRPC and RxSwift (installation is described above).  It can be opened in Xcode, or built with the following command:

```
bash build_dronecode_sdk.bash
```

### Publishing archives to Amazon S3

With the right permissions, one can publish a release to amazon S3 with the following commands:

```
bash create_archives.bash
bash push_archives_to_s3.bash
```
