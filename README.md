# SwiftSystemService

[![Version](https://img.shields.io/cocoapods/v/SwiftSystemService.svg?style=flat)](https://cocoapods.org/pods/SwiftSystemService)
[![License](https://img.shields.io/cocoapods/l/SwiftSystemService.svg?style=flat)](https://cocoapods.org/pods/SwiftSystemService)
[![Platform](https://img.shields.io/cocoapods/p/SwiftSystemService.svg?style=flat)](https://cocoapods.org/pods/SwiftSystemService)

面向 iOS 的系统与设备信息采集库，按功能拆分为多个 **subspec**，可按需依赖。公开 API 以 `NSObject` 子类为主，支持 **Swift** 与 **Objective-C** 混编。

## 功能与子模块

| Subspec | 说明 | 主要类 |
|--------|------|--------|
| （根模块） | `SystemService`：汇总设备信息为字典 | `SystemService` |
| `Network` | 网络类型、代理、VPN、WIFI 信息等 | `NetworkService` |
| `Storage` | 内存、磁盘存储相关信息 | `StorageService` |
| `Time` | 启动时间、系统运行时间等 | `TimeService` |
| `Device` | 屏幕、CPU、IDFA、语言/时区、电量等 | `DeviceService`, `PhoneService` |
| `Broken` | 越狱环境检测 | `BrokenService` |

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

// 异步获取 WIFI 信息
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
let idfa = device.idfa()  // IDFA

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

## Example 工程

克隆仓库后，在 `Example` 目录执行 `pod install`，再打开 `SwiftSystemService.xcworkspace` 运行示例。

## 作者

yanwenbo78201 · yanwenbo78201@gmail.com

## 许可

基于 [MIT License](LICENSE)。