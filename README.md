# DroneCore-Swift SDK for iOS

## Include the SDK for iOS in an Existing Application

There are three ways to import the DroneCore-Swift SDK for iOS into your project:

* [CocoaPods](https://cocoapods.org/)
* [Carthage](https://github.com/Carthage/Carthage) 
* Manually

You should use one of these three ways to import the DroneCore-Swift SDK but not multiple. Importing the SDK in multiple ways loads duplicate copies of the SDK into the project and causes compiler errors.

### CocoaPods

1. The DroneCore-Swift SDK for iOS is available through [CocoaPods](http://cocoapods.org). If you have not installed CocoaPods, install CocoaPods by running the command:

        $ gem install cocoapods
        $ pod setup

    Depending on your system settings, you may have to use `sudo` for installing `cocoapods` as follows:

        $ sudo gem install cocoapods
        $ pod setup

2. In your project directory (the directory where your `*.xcodeproj` file is), create a plain text file named `Podfile` (without any file extension) and add the lines below. Replace `YourTarget` with your actual target name.

        source 'https://github.com/CocoaPods/Specs.git'
        
        platform :ios, '8.0'
        use_frameworks!
        
        target :'YourTarget' do
            pod 'DroneCore-Swift'
        end
        
3. Then run the following command:
    
        $ pod install

4. Open up `*.xcworkspace` with Xcode and start using the SDK.


### Carthage

### Use Carthage to get the framework

To use the DroneCore-Swift SDK in your iOS application, you can pull in this framework using [Carthage](https://github.com/Carthage/Carthage).

To install carthage, it's easiest to use [Homebrew](https://brew.sh/):

```
brew install carthage
```

Then to add the framework, create the file `Cartfile` in your app's repository with below's content:

```
# Require the iOS framework of DroneCore SDK
github "dronecore/DroneCore-Swift"
```

Then, to pull in the library and build it, run Carthage in your app's repository:

```
carthage update
```

This command also needs to be re-run if you want to udpate the framework.

### Add the framework into your project

Open the project in XCode and do the following:

1. Open Project Settings -> General
2. Find Embedded Binaries and press *+*
3. Click Other, go one folder up, and select `Carthage/Build/iOS/Dronecode_SDK_Swift.framework`.
4. Do "Product Clean" and "Product Build"

### Clean up the download automatically done by the build

Dependencies are needed to build Dronecode_SDK_Swift.framework. The script download-dependencies.sh is downloading a zip containing them.
To remove this download:

Open the project Dronecode-SDK-Swift in XCode and do the following:

1. Open Project Settings -> Build Phases
2. Open Run Script tab
3. Put a # before ./download-dependencies.sh or just delete the runscript

### Use Carthage to check out a developer branch

While developing, you might need a developer version of the iOS wrappers. They can be accessed by using a branch in the `Cartfile`:

```
github "dronecore/DroneCore-Swift" "branch-name"
```

### Manually

1. Download the SDK from [here](https://s3.eu-central-1.amazonaws.com/dronecode-sdk/dronecore-swift-prototype.zip)

2. Unzip 'dronecore-swift-prototype.zip'

3. With your project open in Xcode, select your **Target**. Under **General** tab, find **Linked Framework and Libraries** and then click the **+** button.

4. Click the **Add Other...** button, navigate to the unzip folder and select all files. 

    * `backend.framework`
    * `BoringSSL.framework`
    * `CgRPC.framework`
    * `Czlib.framework`
    * `DroneCore_Swift.framework`
    * `gRPC.framework`
    * `RxSwift.framework`
    * `SwiftProtobuf.framework`
    * `SwiftProtobufPluginLibrary.framework`


## Update the SDK to a Newer Version

When we release a new version of the SDK, you can pick up the changes as described below.

### CocoaPods

1. Run the following command in your project directory. CocoaPods automatically picks up the new changes.

        $ pod update

    **Note**: If your pod is having an issue, you can delete `Podfile.lock` and `Pods/` then run `pod install` to cleanly install the SDK.

### Carthage

1. Run the following command in your project directory. Carthage automatically picks up the new changes.

        $ carthage update

### Manually

1. In Xcode select the following frameworks in **Project Navigator** and hit **delete** on your keyboard. Then select **Move to Trash**:

    * `backend.framework`
    * `BoringSSL.framework`
    * `CgRPC.framework`
    * `Czlib.framework`
    * `DroneCore_Swift.framework`
    * `gRPC.framework`
    * `RxSwift.framework`
    * `SwiftProtobuf.framework`

2. Follow the installation process above to include the new version of the SDK.

## Getting Started with Swift

1. In Swift file you want to use the SDK, import DroneCore_Swift framework as in the following example:

    ```swift
    import DroneCore_Swift
    ```
        
4. Example to use the library :	

    ```swift
    let action = Action()
    sleep(5) // this is a hack for this prototype
    action.arm().subscribe()
    ```


    ```swift
    let action = Action()
        
        sleep(5) // this is a hack for this prototype
        
        let myRoutine = action.arm()
            .do(onError: { error in print("Arming failed") },
                onCompleted: { print("Arming succeeded") })
            .andThen(action.takeoff()
                .do(onError: { error in print("Takeoff failed") },
                    onCompleted: { print("Takeoff succeeded") })
                .delay(15, scheduler: MainScheduler.instance))
            .andThen(action.land()
                .do(onError: { error in print("Landing failed") },
                    onCompleted: { print("Landing succeeded") }));
        
        myRoutine.subscribe()
    ```
