#
# 发布前请执行: pod lib lint SwiftSystemService.podspec
# 语法说明: https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SwiftSystemService'
  s.version          = '0.1.2'
  s.summary          = 'iOS 设备与系统信息采集（网络、存储、时间、设备、越狱检测等），支持 Swift / Objective-C。'

  s.description      = <<-DESC
    聚合常用系统能力，按子模块（subspec）拆分依赖，可按需只引入部分功能。

    - Network：网络类型、代理、VPN 等
    - Storage：内存等存储相关信息
    - Time：启动时间等
    - Device：屏幕、CPU、IDFA、语言时区、电量等
    - Broken：越狱环境相关检测
    - 根 spec 仅含 SystemService 入口，用于汇总设备信息字典

    主要类型继承 NSObject 并暴露给 Objective-C，便于混编工程调用。
                       DESC

  s.homepage         = 'https://github.com/yanwenbo78201/SwiftSystemService'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'yanwenbo78201' => 'yanwenbo78201@gmail.com' }
  s.source           = { :git => 'https://github.com/yanwenbo78201/SwiftSystemService.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'
  s.swift_version = '5.0'

  # 仅入口放在根 spec，避免与各 subspec 目录下的源码重复编译。
  s.source_files = 'SwiftSystemService/Classes/SystemService.swift'

  # `pod 'SwiftSystemService'` 默认依赖全部 subspec；也可只选其一，例如 `pod 'SwiftSystemService/Network'`。
  # 勿将 .swift 写入 public_header_files，否则 CocoaPods 会生成错误的 umbrella（#import "*.swift"）。

  s.subspec 'Network' do |network|
    network.source_files = 'SwiftSystemService/Classes/Network/**/*'
    network.frameworks = 'UIKit', 'CoreTelephony', 'AppTrackingTransparency'
  end

  s.subspec 'Broken' do |broken|
    broken.source_files = 'SwiftSystemService/Classes/Broken/**/*'
    broken.frameworks = 'UIKit'
  end

  s.subspec 'Storage' do |storage|
    storage.source_files = 'SwiftSystemService/Classes/Storage/**/*'
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

  s.frameworks = 'UIKit', 'CoreTelephony', 'AppTrackingTransparency', 'AdSupport'
end
