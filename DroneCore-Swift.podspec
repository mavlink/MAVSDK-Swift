#
# Be sure to run `pod lib lint DroneCore-Swift.podspec' 
# to ensure this is a valid spec before submitting.
#
# Any lines starting with a # are optional
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html

Pod::Spec.new do |spec|
  spec.name             = "DroneCore-Swift"
  spec.version          = "0.0.6"
  spec.summary          = "DronecodeSDK client for Swift"

# This description is used to generate tags and improve search results.
  spec.description     = "DronecodeSDK client for Swift"
  spec.homepage        = "https://github.com/dronecore/DroneCore-Swift"
  spec.license         = { :type => 'BSD', :file => 'LICENSE.md' }
  spec.author          = { "ayameMBS" => "marjory.silvestre@gmail.com" }
  spec.platform        = :ios, '11.0'
  spec.requires_arc    = true
  spec.source          = { :http => "https://s3.eu-central-1.amazonaws.com/dronecode-sdk/dronecode-sdk-swift-latest.zip"}
  spec.vendored_frameworks = 'backend.framework','Dronecode_SDK_Swift.framework','RxSwift.framework','RxBlocking.framework'
  spec.dependency 'SwiftGRPC', '= 0.4.2'
end
