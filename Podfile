platform :ios, '12.0'
use_frameworks!
inhibit_all_warnings!

target 'SwiftTemplate' do
  pod 'SnapKit', '~> 5.0.1'
  pod 'Alamofire', '~> 5.2.1'
  pod 'MJRefresh', '~> 3.4'
  pod 'Kingfisher', '~> 5.14'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
    end
  end
end
