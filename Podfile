
# Comment this line if you're not using Swift and don't want to use dynamic frameworks
use_frameworks!

# ignore all warnings from all pods
inhibit_all_warnings!

target 'RxSonosLib' do
  platform :ios, '16.0'

  pod 'RxSwift', '~> 5'
  pod 'RxSSDP', '~> 5.0'
  pod 'AEXML', '~> 4.6.1'
  pod 'SwiftLint'

  target 'RxSonosLibTests' do
    inherit! :search_paths

    pod 'Mockingjay', :git => 'https://github.com/kylef/Mockingjay', :commit => 'b88c9dce2b7561cccbf35e2882b3c71a2efa387a'
    pod 'RxBlocking', '~> 5'
  end

end

target 'iOS Demo App' do
  platform :ios, '16.0'

  pod 'RxSonosLib', :path => '.'
  pod 'RxSwift', '~> 5'
  pod 'RxCocoa', '~> 5'
end

# Disable Code Coverage for Pods projects
# Disable Dsym Generation in Mock Config for faster test build
post_install do |installer_representation|
  installer_representation.generated_projects.each do |project|
    project.targets.each do |target|
      target.build_configurations.each do |config|
          config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '16.0'
      end
    end
  end

  installer_representation.pods_project.targets.each do |target|
    if ["Mockingjay", "URITemplate"].include? target.name
      target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = "4.2"
      end
    end
  end
end
