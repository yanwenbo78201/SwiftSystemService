# SwiftSystemService

[![Version](https://img.shields.io/cocoapods/v/SwiftSystemService.svg?style=flat)](https://cocoapods.org/pods/SwiftSystemService)
[![License](https://img.shields.io/cocoapods/l/SwiftSystemService.svg?style=flat)](https://cocoapods.org/pods/SwiftSystemService)
[![Platform](https://img.shields.io/cocoapods/p/SwiftSystemService.svg?style=flat)](https://cocoapods.org/pods/SwiftSystemService)

面向 iOS 的系统与设备信息采集库，按功能拆分为多个 **subspec**，可按需依赖。公开 API 以 `NSObject` 子类为主，支持 **Swift** 与 **Objective-C** 混编。

## 功能与子模块

| Subspec | 说明 |
|--------|------|
| （根模块） | `SystemService`：汇总设备信息为字典 |
| `Network` | 网络类型、代理、VPN 等 |
| `Storage` | 内存等存储相关信息 |
| `Time` | 启动时间等 |
| `Device` | 屏幕、CPU、IDFA、语言/时区、电量等 |
| `Broken` | 越狱环境相关检测 |

默认 `pod 'SwiftSystemService'` 会引入全部子模块；若只需部分能力，可指定 subspec，例如：

```ruby
pod 'SwiftSystemService/Network'
pod 'SwiftSystemService/Device'
```

## 环境要求

- iOS 10.0+
- Swift 5.0+
- Xcode 与 CocoaPods 建议使用当前稳定版本

## 安装

在 Podfile 中加入：

```ruby
pod 'SwiftSystemService'
```

然后执行：

```bash
cd Example
pod install
```

## 使用示例

**Swift**

```swift
import SwiftSystemService

let info = SystemService.getDeviceInfo(uuid: "your-uuid")
let network = NetworkService()
_ = network.networkTypeDetail()
```

**Objective-C**

```objc
@import SwiftSystemService;

NSDictionary *info = [SystemService getDeviceInfoWithUuid:@"your-uuid"];
NetworkService *network = [[NetworkService alloc] init];
NSString *type = [network networkTypeDetail];
```

（具体方法名以 Swift 导出至 ObjC 的符号为准，可在 Xcode 中 `⌥` 点击查看。）

## Example 工程

克隆仓库后，在 `Example` 目录执行 `pod install`，再打开 `SwiftSystemService.xcworkspace` 运行示例。

## 作者

yanwenbo78201 · yanwenbo78201@gmail.com

## 许可

基于 [MIT License](LICENSE)。
