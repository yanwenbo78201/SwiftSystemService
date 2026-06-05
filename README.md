# SwiftSystemService

[![Version](https://img.shields.io/cocoapods/v/SwiftSystemService.svg?style=flat)](https://cocoapods.org/pods/SwiftSystemService)
[![License](https://img.shields.io/cocoapods/l/SwiftSystemService.svg?style=flat)](https://cocoapods.org/pods/SwiftSystemService)
[![Platform](https://img.shields.io/cocoapods/p/SwiftSystemService.svg?style=flat)](https://cocoapods.org/pods/SwiftSystemService)

面向 iOS 的系统与设备信息采集库，按功能拆分为多个 **subspec**，可按需依赖。公开 API 以 `NSObject` 子类为主，支持 **Swift** 与 **Objective-C** 混编。

## 特性

- 📦 **模块化设计**：按功能拆分为多个 subspec，可按需引入
- 🔄 **异步支持**：WIFI 信息等敏感操作采用异步获取，避免阻塞主线程
- 🎯 **类型安全**：所有公开 API 均为强类型，提供良好的代码提示
- 🌐 **双语言支持**：同时支持 Swift 和 Objective-C
- 📱 **全面覆盖**：涵盖网络、存储、时间、设备、越狱检测等多个维度

## 功能与子模块

| Subspec | 说明 | 主要类 | 依赖框架 |
|--------|------|--------|----------|
| （根模块） | `SystemService`：汇总设备信息为字典 | `SystemService` | UIKit, CoreTelephony, AppTrackingTransparency, AdSupport |
| `Network` | 网络类型、代理、VPN、WIFI 信息等 | `NetworkService` | UIKit, CoreTelephony, AppTrackingTransparency |
| `Storage` | 内存、磁盘存储相关信息 | `StorageService` | UIKit |
| `Time` | 启动时间、系统运行时间等 | `TimeService` | UIKit |
| `Device` | 屏幕、CPU、IDFA、语言/时区、电量等 | `DeviceService`, `PhoneService` | UIKit, CoreTelephony, AppTrackingTransparency, AdSupport |
| `Broken` | 越狱环境检测 | `BrokenService` | UIKit |

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

### Swift

```swift
import SwiftSystemService

// 异步获取设备信息（推荐）
SystemService.getDeviceInfo(uuid: "your-uuid") { info in
    print(info)
    // info 包含: uuid, screenResolution, screenWidth, screenHeight, cpuNum, 
    // ramTotal, ramCanUse, batteryLevel, charged, totalBootTime, 
    // totalBootTimeWake, defaultLanguage, defaultTimeZone, idfa, idfv, 
    // phoneMark, phoneType, systemVersions, versionCode, network, 
    // wifiName, wifiBssid, isvpn, lastBootTime, proxied, 
    // simulated, debugged, screenBrightness, cashTotal, cashCanUse, rooted
}

// 网络信息
let network = NetworkService()
let networkType = network.networkTypeDetail()  // "WiFi", "4G", "5G", etc.
let networkNumber = network.networkTypeNumber() // "0"-"5"
let isVpn = network.isVpn()  // "true" or "false"
let isProxied = network.proxied()  // "true" or "false"

// 异步获取 WIFI 信息（需要特殊权限）
network.wifiInfo { wifiDict in
    let ssid = wifiDict?["ssid"]
    let bssid = wifiDict?["bssid"]
}

// 存储信息
let storage = StorageService()
let ramTotal = storage.ramTotal()  // 总内存（GB）
let ramCanUse = storage.ramCanUse()  // 可用内存（GB）
let diskTotal = storage.cashTotal()  // 总磁盘空间（GB）
let diskFree = storage.cashCanUse()  // 可用磁盘空间（GB）

// 时间信息
let time = TimeService()
let bootTime = time.totalBootTime()  // 系统启动时长（毫秒）
let uptime = time.totalBootTimeWake()  // 系统运行时长（毫秒）
let lastBoot = time.lastBootTime()  // 上次启动时间戳（毫秒）

// 设备信息
let device = DeviceService()
let screenResolution = device.screenResolution()  // "width-height"
let brightness = device.screenBrightness()  // 屏幕亮度百分比
let cpuCount = device.cpuNum()  // CPU核心数
let battery = device.batteryLevel()  // 电池电量百分比
let isCharging = device.charged()  // 是否充电中
let language = device.defaultLanguage()  // 默认语言
let isDebugged = device.debugStatus()  // 是否处于调试状态
let idfa = device.idfa()  // IDFA（iOS 14+ 会请求权限）

// 设备型号
let phone = PhoneService()
let modelName = phone.deviceModelName()  // "iPhone 15 Pro"
let deviceType = phone.deviceTypeNumber()  // "3" (iPhone), "2" (iPad), "1" (Mac), "0" (other)
let uaType = phone.deviceUAType()  // "Mobile", "Tablet", "pc", "unknown"

// 越狱检测
let broken = BrokenService()
let isRooted = broken.brokenCrackStatus()  // "true" or "false"
```

### Objective-C

```objc
@import SwiftSystemService;

// 异步获取设备信息
[SystemService getDeviceInfoWithUuid:@"your-uuid" completion:^(NSDictionary *info) {
    NSLog(@"%@", info);
}];

// 网络信息
NetworkService *network = [[NetworkService alloc] init];
NSString *networkType = [network networkTypeDetail];
NSString *isVpn = [network isVpn];
NSString *isProxied = [network proxied];

// 异步获取 WIFI 信息
[network wifiInfoWithCompletion:^(NSDictionary *wifiDict) {
    NSString *ssid = wifiDict[@"ssid"];
    NSString *bssid = wifiDict[@"bssid"];
}];

// 存储信息
StorageService *storage = [[StorageService alloc] init];
NSString *ramTotal = [storage ramTotal];
NSString *ramCanUse = [storage ramCanUse];

// 时间信息
TimeService *time = [[TimeService alloc] init];
NSString *bootTime = [time totalBootTime];

// 设备信息
DeviceService *device = [[DeviceService alloc] init];
NSString *resolution = [device screenResolution];
NSString *battery = [device batteryLevel];
NSString *idfa = [device idfa];

// 设备型号
PhoneService *phone = [[PhoneService alloc] init];
NSString *modelName = [phone deviceModelName];

// 越狱检测
BrokenService *broken = [[BrokenService alloc] init];
NSString *isRooted = [broken brokenCrackStatus];
```

## 返回数据字段说明

`SystemService.getDeviceInfo` 返回的字典包含以下字段：

| 字段 | 类型 | 说明 |
|------|------|------|
| uuid | String | 用户传入的 UUID |
| screenResolution | String | 屏幕分辨率（如 "1170-2532"） |
| screenWidth | String | 屏幕宽度（逻辑像素） |
| screenHeight | String | 屏幕高度（逻辑像素） |
| cpuNum | String | CPU 核心数 |
| ramTotal | String | 总内存（GB） |
| ramCanUse | String | 可用内存（GB） |
| batteryLevel | String | 电池电量百分比（0-100） |
| charged | String | 是否充电中（"true"/"false"） |
| totalBootTime | String | 系统启动时长（毫秒） |
| totalBootTimeWake | String | 系统运行时长（毫秒） |
| defaultLanguage | String | 默认语言（如 "zh"） |
| defaultTimeZone | String | 默认时区标识 |
| idfa | String | IDFA（广告标识符） |
| idfv | String | IDFV（应用标识符） |
| phoneMark | String | 设备名称 |
| phoneType | String | 设备型号名称 |
| systemVersions | String | iOS 版本号 |
| versionCode | String | 应用版本号 |
| network | String | 网络类型数字编码（0-5） |
| wifiName | String | WIFI 名称 |
| wifiBssid | String | WIFI BSSID |
| isvpn | String | 是否使用 VPN（"true"/"false"） |
| lastBootTime | String | 上次启动时间戳（毫秒） |
| proxied | String | 是否使用代理（"true"/"false"） |
| simulated | String | 是否在模拟器运行（"true"/"false"） |
| debugged | String | 是否处于调试状态（"true"/"false"） |
| screenBrightness | String | 屏幕亮度百分比（0-100） |
| cashTotal | String | 总磁盘空间（GB） |
| cashCanUse | String | 可用磁盘空间（GB） |
| rooted | String | 是否越狱（"true"/"false"） |

## 网络类型编码

| 编码 | 网络类型 |
|------|----------|
| 0 | Unknown / 不可达 |
| 1 | WiFi |
| 2 | 2G |
| 3 | 3G |
| 4 | 4G |
| 5 | 5G |

## 注意事项

### 权限要求

- **WIFI 信息获取**：需要在 `Info.plist` 中添加以下权限：
  ```xml
  <key>NSAppTransportSecurity</key>
  <dict>
      <key>NSAllowsArbitraryLoads</key>
      <true/>
  </dict>
  ```
  对于 iOS 13+，还需要添加：
  ```xml
  <key>NSLocationWhenInUseUsageDescription</key>
  <string>需要获取 WIFI 信息</string>
  <key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
  <string>需要获取 WIFI 信息</string>
  ```

- **IDFA 获取**：iOS 14+ 需要请求用户授权，库会自动处理权限请求流程。

### 异步调用

以下方法为异步调用，需要通过闭包/回调获取结果：
- `SystemService.getDeviceInfo(uuid:completion:)` - 获取完整设备信息
- `NetworkService.wifiInfo(completion:)` - 获取 WIFI 信息

### 设备兼容性

- iOS 14.0+：使用 `NEHotspotNetwork` 获取 WIFI 信息
- iOS 10.0-13.x：使用 `CNCopyCurrentNetworkInfo` 获取 WIFI 信息（需要特殊权限）

## Example 工程

克隆仓库后，在 `Example` 目录执行 `pod install`，再打开 `SwiftSystemService.xcworkspace` 运行示例。

## 常见问题

### 1. WIFI 信息获取失败？

- 检查是否添加了必要的权限配置
- 确保设备已连接 WIFI 网络
- 在真机上测试，模拟器可能无法获取 WIFI 信息

### 2. IDFA 返回 "null"？

- iOS 14+ 需要用户授权，首次调用时会弹出权限请求
- 用户拒绝授权后，IDFA 将返回 "null"

### 3. 越狱检测结果不准确？

- 越狱检测基于多种检测方式，可能存在误判
- 建议结合业务场景综合判断

## 更新日志

### 0.1.5
- 将 WIFI 信息获取改为异步方式
- 更新 `SystemService.getDeviceInfo` 为异步方法
- 优化 iOS 14+ WIFI 信息获取方式

## 作者

yanwenbo78201 · yanwenbo78201@gmail.com

## 许可

基于 [MIT License](LICENSE)。

## 相关链接

- [GitHub 仓库](https://github.com/yanwenbo78201/SwiftSystemService)
- [CocoaPods 页面](https://cocoapods.org/pods/SwiftSystemService)
- [问题反馈](https://github.com/yanwenbo78201/SwiftSystemService/issues)