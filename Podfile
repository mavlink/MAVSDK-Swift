platform :ios, '11.0'

target 'MAVSDK_Swift' do
  use_frameworks!

  $rxUrl = 'https://github.com/ReactiveX/RxSwift.git'
  $grpcCommitHash = '820730e24b9cf035b2889b30d2fe87411e041720'

  # Pods for Dronecode-SDK-Swift
  pod 'SwiftGRPC', :git => 'https://github.com/JonasVautherin/grpc-swift.git', :commit => $grpcCommitHash
  pod 'RxSwift', :git => $rxUrl

  target 'MAVSDK_SwiftTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'RxBlocking', :git => $rxUrl, :commit => $rxCommitHash
    pod 'RxTest', :git => $rxUrl
  end

  target 'MAVSDK_SwiftIntegrationTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'RxBlocking', :git => $rxUrl, :commit => $rxCommitHash
    pod 'RxTest', :git => $rxUrl
  end
end

post_install do |installer_representation|
  installer_representation.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
    end
  end
end
