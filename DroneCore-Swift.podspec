#
# Be sure to run `pod lib lint DroneCore-Swift.podspec' 
# to ensure this is a valid spec before submitting.
#
# Any lines starting with a # are optional
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html

Pod::Spec.new do |spec|
  spec.name             = "DroneCore-Swift"
  spec.version          = "0.0.1"
  spec.summary          = "DroneCore client for swift"

# This description is used to generate tags and improve search results.
  spec.description     = "DroneCore client for swift initialisation"
  spec.homepage        = "https://github.com/dronecore/DroneCore-Swift"
  spec.license         = 'MIT'
  spec.author          = { "ayameMBS" => "marjory.silvestre@gmail.com" }
  spec.platform        = :ios, '11.0'
  spec.requires_arc    = true
  spec.source          = { :http => "https://s3.eu-central-1.amazonaws.com/dronecode-sdk/dronecore-swift-prototype.zip"}
  spec.vendored_frameworks = 'backend.framework','BoringSSL.framework','CgRPC.framework','Czlib.framework','DroneCore_Swift.framework','gRPC.framework','RxSwift.framework','SwiftProtobuf.framework','SwiftProtobufPluginLibrary.framework'
end