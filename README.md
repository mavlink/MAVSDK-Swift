# DroneCore-Swift SDK for iOS

## Include the SDK for iOS in an Existing Application

There are three ways to import the DroneCore-Swift SDK for iOS into your project:

* [CocoaPods](https://cocoapods.org/)
* [Carthage](https://github.com/Carthage/Carthage) Coming soon
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

Coming soon

### Frameworks

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

### Frameworks

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
