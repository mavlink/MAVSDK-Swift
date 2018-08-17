platform :ios, '9.0'

target 'Dronecode-SDK-Swift' do
  use_frameworks!

  $gRPCVersion = '= 0.4.2'
  $rxVersion = '= 4.0'

  # Pods for Dronecode-SDK-Swift
  pod 'SwiftGRPC', $gRPCVersion
  pod 'RxSwift', $rxVersion

  target 'Dronecode-SDK-SwiftTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'RxBlocking', $rxVersion
    pod 'RxTest', $rxVersion
  end

  target 'Dronecode_SDK_SwiftIntegrationTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'RxBlocking', $rxVersion
    pod 'RxTest', $rxVersion
  end
end

post_install do |installer_representation|
  installer_representation.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
    end
  end
end
