source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
use_frameworks!


def common_pods
    pod 'Alamofire'
    pod 'ObjectMapper'
    pod 'Kingfisher'
    pod 'SnapKit'
    pod 'IQKeyboardManagerSwift'
    pod 'ESTabBarController-swift'
    pod 'SKPhotoBrowser'
    
end

def sdk_pods

end

def temp_pods
    pod 'Pitaya'
    pod 'WCDB.swift'
    pod 'Kanna'
    pod 'Ji'
end

target 'ZiMu' do
    common_pods

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '4.0'
        end
    end
end
