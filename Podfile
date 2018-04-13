source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
use_frameworks!


def common_pods
    pod 'Alamofire'
    pod 'ObjectMapper'
    pod 'Kingfisher'
    pod 'SnapKit'
    pod 'ESTabBarController-swift'
    pod 'MJRefresh'
    pod 'Hero'
    pod 'FMDB', '~> 2.6.2'
    
end

def sdk_pods
    pod 'UMCCommon'
    pod 'UMCAnalytics'
end

def temp_pods
    pod 'WCDB.swift'
    pod 'Kanna'
    pod 'AcknowList'
end

target 'ZiMu' do
    common_pods
    sdk_pods
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '4.0'
        end
    end
end
