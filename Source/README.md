# Building Dronecode-SDK-Swift

## Install dependencies

### Cocoapods dependencies

Run the following command from the root of the SDK:

```
pod install
```

### Vendor dependencies

The backend framework needs to be fetched (and will end up in `bin/`):

```
bash fetch_backend.bash
```

## Build SDK framework

Dronecode-SDK-Swift depends on gRPC and RxSwift (installation is described above). It can be opened in Xcode (open the workspace created by Cocoapods), or built with the following command:

```
bash build_dronecode_sdk.bash
```

## Publishing archives to Amazon S3

With the right permissions, one can publish a release to Amazon S3 with the following commands:

```
bash create_archives.bash
bash push_archives_to_s3.bash
```
