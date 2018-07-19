# DroneCore-Swift SDK for iOS

## Include the SDK for iOS in an Existing Application

### CocoaPods

1. The DroneCore-Swift SDK for iOS is available through [CocoaPods](http://cocoapods.org). CocoaPods can be installed with the following commands:

        $ gem install cocoapods
        $ pod setup

2. In your project directory (the directory where your `*.xcodeproj` file is), create a plain text file named `Podfile` (without any file extension) and add the lines below. Replace `YourTarget` with your actual target name.

        source 'https://github.com/CocoaPods/Specs.git'
        
        platform :ios, '8.0'
        use_frameworks!
        
        target :'YourTarget' do
            pod 'DroneCore-Swift', '= 0.1.0'
        end
        
3. Then run the following command:
    
        $ pod install

4. Open up `*.xcworkspace` with Xcode and start using the SDK.


## Update the SDK to a Newer Version

When we release a new version of the SDK, you can pick up the changes as described below.

### CocoaPods

1. Update the version number in your Podfile.

2. Run the following command in your project directory. CocoaPods automatically picks up the new changes.

        $ pod update

    **Note**: If your pod is having an issue, you can delete `Podfile.lock` and `Pods/` then run `pod install` to cleanly install the SDK.
