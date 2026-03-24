#
# Be sure to run `pod lib lint SwiftSystemService.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SwiftSystemService'
  s.version          = '0.1.0'
  s.summary          = 'A short description of SwiftSystemService.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/yanwenbo78201/SwiftSystemService'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'yanwenbo78201' => 'yanwenbo78201@gmail.com' }
  s.source           = { :git => 'https://github.com/yanwenbo78201/SwiftSystemService.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'
  s.swift_version = '5.0'
  
  # 仅入口文件放在根 spec，避免与各 subspec 的目录重复编译。
  s.source_files = 'SwiftSystemService/Classes/SystemService.swift'

  # 源码按子规格划分；`pod 'SwiftSystemService'` 默认包含全部子规格。
  # 勿将 .swift 写入 public_header_files，否则 CocoaPods 会生成错误的 umbrella（#import "*.swift"）。
  s.subspec 'Network' do |network|
    network.source_files = 'SwiftSystemService/Classes/Network/**/*'
    network.frameworks = 'UIKit', 'CoreTelephony', 'AppTrackingTransparency'
  end

  s.subspec 'Storage' do |storage|
    storage.source_files = 'SwiftSystemService/Classes/Storage/**/*'
    # Darwin 仅作 Swift `import Darwin`，不是可链接的 framework，勿写入 frameworks。
    storage.frameworks = 'UIKit'
  end

  s.subspec 'Time' do |time|
    time.source_files = 'SwiftSystemService/Classes/Time/**/*'
    time.frameworks = 'UIKit'
  end

  s.subspec 'Device' do |device|
    device.source_files = 'SwiftSystemService/Classes/Device/**/*'
    device.frameworks = 'UIKit', 'CoreTelephony', 'AppTrackingTransparency', 'AdSupport'
  end
  
  # s.resource_bundles = {
  #   'SwiftSystemService' => ['SwiftSystemService/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.frameworks = 'UIKit', 'CoreTelephony', 'AppTrackingTransparency', 'AdSupport'
  # s.dependency 'AFNetworking', '~> 2.3'
end
