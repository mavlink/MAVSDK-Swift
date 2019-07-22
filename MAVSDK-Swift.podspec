#
# Be sure to run `pod lib lint DroneCore-Swift.podspec' 
# to ensure this is a valid spec before submitting.
#
# Any lines starting with a # are optional
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html

currentVersion = '0.6.0'
mavsdkServerVersion = '0.18.3'

Pod::Spec.new do |spec|
  spec.name             = "MAVSDK-Swift"
  spec.version          = currentVersion
  spec.summary          = "MAVSDK"

# This description is used to generate tags and improve search results.
  spec.description     = "MAVSDK client for Swift"
  spec.homepage        = "https://github.com/dronecore/MAVSDK-Swift"
  spec.license         = { :type => 'BSD', :file => 'LICENSE.md' }
  spec.author          = { "ayameMBS" => "marjory.silvestre@gmail.com" }
  spec.platform        = :ios, '11.0'
  spec.requires_arc    = true
  spec.source          = { :http => 'https://s3.eu-central-1.amazonaws.com/dronecode-sdk/mavsdk_server_#{mavsdkServerVersion}.zip' }
  spec.source_files    = 'MAVSDK_Swift', 'Sources/MAVSDK-Swift/**/*.{h,m,swift}'
  spec.vendored_frameworks = 'mavsdk_server.framework', 'MAVSDK_Swift.framework'
  spec.dependency 'SwiftGRPC'
  spec.dependency 'RxSwift'
end
