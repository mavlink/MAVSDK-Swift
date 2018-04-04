# Building Dronecode-SDK-Swift

## Install dependencies

### Prebuilt

1. Download dependencies by running `bash fetch_archive_sdk.bash`. They will be unzipped in `bin/`.
2. Open Dronecode-SDK-Swift.xcodeproj in Xcode.
3. It should just work.

### Build from sources

Dependencies (gRPC and RxSwift) can be built from sources with the following commands:

```
bash build_grpc.bash
bash build_rxswift.bash
```

The backend framework needs to be fetched:

```
bash fetch_backend.bash
```

All the dependencies will end up in `bin/`.

## Build SDK framework

Dronecode-SDK-Swift depends on gRPC and RxSwift (installation is described above).  It can be opened in Xcode, or built with the following command:

```
bash build_dronecode_sdk.bash
```

## Publishing archives to Amazon S3

With the right permissions, one can publish a release to amazon S3 with the following commands:

```
bash create_archives.bash
bash push_archives_to_s3.bash
```
