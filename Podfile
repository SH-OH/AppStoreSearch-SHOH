source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '11.0'
use_frameworks!

def default_pods
  pod 'ReactorKit'
  pod 'SnapKit'
  pod 'Then'
  pod 'DeviceKit'

  rx_pods
end

def rx_pods
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'RxGesture'
end

def ui_pods
  pod 'ActiveLabel'
end

def test_pods
  pod 'RxExpect', :git => 'https://github.com/SH-OH/RxExpect.git', :branch => 'develop'
end

target 'AppStoreSearch-SHOH' do
    default_pods
    ui_pods
end

target 'AppStoreSearch-SHOHTests' do
    inherit! :search_paths
    default_pods
    test_pods
end

target 'AppStoreSearch-SHOHUITests' do
    test_pods
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
    end
  end
end