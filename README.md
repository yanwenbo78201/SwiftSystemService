# SwiftSystemService

[![Version](https://img.shields.io/cocoapods/v/SwiftSystemService.svg?style=flat)](https://cocoapods.org/pods/SwiftSystemService)
[![License](https://img.shields.io/cocoapods/l/SwiftSystemService.svg?style=flat)](https://cocoapods.org/pods/SwiftSystemService)
[![Platform](https://img.shields.io/cocoapods/p/SwiftSystemService.svg?style=flat)](https://cocoapods.org/pods/SwiftSystemService)
[![Swift](https://img.shields.io/badge/Swift-5.0-orange.svg)](https://swift.org)

面向 iOS 的系统与设备信息采集库，按功能拆分为多个 **subspec**，可按需依赖。公开 API 以 `NSObject` 子类为主，支持 **Swift** 与 **Objective-C** 混编。

## ✨ 特性

- 📦 **模块化设计**：按功能拆分为多个 subspec，可按需引入，减小包体积
- 🔄 **异步支持**：WIFI 信息等敏感操作采用异步获取，避免阻塞主线程
- 🎯 **类型安全**：所有公开 API 均为强类型，提供良好的代码提示
- 🌐 **双语言支持**：同时支持 Swift 和 Objective-C，便于混编项目使用
- 📱 **全面覆盖**：涵盖网络、存储、时间、设备、越狱检测等多个维度
- 🚀 **高性能**：轻量级实现，无第三方依赖，内存占用小
- 📊 **设备兼容**：支持 iOS 10.0+，覆盖主流设备型号

## 📦 功能与子模块

| Subspec | 说明 | 主要类 | 依赖框架 |
|--------|------|--------|----------|
| （根模块） | `SystemService`：汇总设备信息为字典 | `SystemService` | UIKit, CoreTelephony, AppTrackingTransparency, AdSupport |
| `Network` | 网络类型、代理、VPN、WIFI 信息等 | `NetworkService` | UIKit, CoreTelephony, AppTrackingTransparency |
| `Storage` | 内存、磁盘存储相关信息 | `StorageService` | UIKit |
| `Time` | 启动时间、系统运行时间等 | `TimeService` | UIKit |
| `Device` | 屏幕、CPU、IDFA、语言/时区、电量等 | `DeviceService`, `PhoneService` | UIKit, CoreTelephony, AppTrackingTransparency, AdSupport |
| `Broken` | 越狱环境检测 | `BrokenService` | UIKit |

**安装方式：**

```ruby
# 安装全部功能
pod 'SwiftSystemService'

# 按需安装单个模块
pod 'SwiftSystemService/Network'
pod 'SwiftSystemService/Device'
```

## 📋 环境要求

- iOS 10.0+
- Swift 5.0+
- Xcode 12.0+
- CocoaPods 1.10.0+

## 🚀 快速开始

### 安装

在 Podfile 中加入：

```ruby
pod 'SwiftSystemService'
```

然后执行：

```bash
cd Example
pod install
```

### 基础使用

```swift
import SwiftSystemService

// 异步获取完整设备信息（包含 WiFi 信息）
SystemService.getDeviceInfoAsync(uuid: "your-uuid") { info in
    print("设备信息：\(info)")
    
    // 获取特定字段
    if let networkType = info["network"] {
        print("网络类型：\(networkType)")
    }
}

// 同步获取设备信息（不含 WiFi 信息，快速响应）
let info = SystemService.getDeviceInfoDataSyncWithOutWifi(uuid: "your-uuid")
print("设备信息：\(info)")
```

## 💻 使用示例

### Swift

```swift
import SwiftSystemService

// MARK: - 设备信息汇总（异步，包含 WiFi 信息）

// 带 UUID 的异步方法
SystemService.getDeviceInfoAsync(uuid: "user-123") { info in
    print("设备型号：\(info["phoneType"] ?? "unknown")")
    print("系统版本：\(info["systemVersions"] ?? "unknown")")
    print("网络类型：\(info["network"] ?? "unknown")")
    print("WiFi 名称：\(info["wifiName"] ?? "unknown")")
    print("WiFi BSSID：\(info["wifiBssid"] ?? "unknown")")
}

// 不带 UUID 的异步方法
SystemService.getDeviceInfoAsyncWithOutUuid { info in
    print("设备信息：\(info)")
}

// MARK: - 设备信息汇总（同步，不含 WiFi 信息）

// 带 UUID 的同步方法
let infoWithUuid = SystemService.getDeviceInfoDataSyncWithOutWifi(uuid: "user-123")
print("设备型号：\(infoWithUuid["phoneType"] ?? "unknown")")

// 不带 UUID 的同步方法
let infoWithoutUuid = SystemService.getDeviceInfoDataSyncWithOutWifi()
print("设备型号：\(infoWithoutUuid["phoneType"] ?? "unknown")")

// MARK: - 网络信息
let network = NetworkService()

// 获取网络类型详情
let networkType = network.networkTypeDetail()  // "WiFi", "4G", "5G", "notReachable"
let networkCode = network.networkTypeNumber()  // "0"-"5"

// 检测网络状态
let isVpn = network.isVpn()  // "true" or "false"
let isProxied = network.proxied()  // "true" or "false"

// 异步获取 WIFI 信息
network.wifiInfo { wifiDict in
    if let ssid = wifiDict?["ssid"] {
        print("已连接 WIFI：\(ssid)")
    }
}

// MARK: - 存储信息
let storage = StorageService()

print("总内存：\(storage.ramTotal()) GB")
print("可用内存：\(storage.ramCanUse()) GB")
print("总磁盘：\(storage.cashTotal()) GB")
print("可用磁盘：\(storage.cashCanUse()) GB")

// MARK: - 时间信息
let time = TimeService()

print("系统启动时长：\(time.totalBootTime()) 毫秒")
print("系统运行时长：\(time.totalBootTimeWake()) 毫秒")
print("上次启动时间：\(time.lastBootTime())")

// MARK: - 设备信息
let device = DeviceService()

print("屏幕分辨率：\(device.screenResolution())")
print("CPU 核心数：\(device.cpuNum())")
print("电池电量：\(device.batteryLevel())%")
print("是否充电：\(device.charged())")
print("屏幕亮度：\(device.screenBrightness())%")
print("默认语言：\(device.defaultLanguage())")
print("调试状态：\(device.debugStatus())")

// IDFA 获取（iOS 14+ 会自动请求权限）
let idfa = device.idfa()
print("IDFA：\(idfa)")

// MARK: - 设备型号
let phone = PhoneService()

print("设备型号：\(phone.deviceModelName())")  // "iPhone 15 Pro"
print("设备类型：\(phone.deviceTypeNumber())")  // "3" (iPhone)
print("UA 类型：\(phone.deviceUAType())")  // "Mobile"

// MARK: - 越狱检测
let broken = BrokenService()
let isRooted = broken.brokenCrackStatus()
print("是否越狱：\(isRooted)")
```

### Objective-C

```objc
@import SwiftSystemService;

// MARK: - 设备信息汇总（异步，包含 WiFi 信息）

// 带 UUID 的异步方法
[SystemService getDeviceInfoAsyncWithUuid:@"user-123" completion:^(NSDictionary *info) {
    NSLog(@"设备型号：%@", info[@"phoneType"]);
    NSLog(@"系统版本：%@", info[@"systemVersions"]);
    NSLog(@"WiFi 名称：%@", info[@"wifiName"]);
}];

// 不带 UUID 的异步方法
[SystemService getDeviceInfoAsyncWithOutUuid:^(NSDictionary *info) {
    NSLog(@"设备信息：%@", info);
}];

// MARK: - 设备信息汇总（同步，不含 WiFi 信息）

// 带 UUID 的同步方法
NSDictionary *infoWithUuid = [SystemService getDeviceInfoDataSyncWithOutWifiWithUuid:@"user-123"];
NSLog(@"设备型号：%@", infoWithUuid[@"phoneType"]);

// 不带 UUID 的同步方法
NSDictionary *infoWithoutUuid = [SystemService getDeviceInfoDataSyncWithOutWifi];
NSLog(@"设备型号：%@", infoWithoutUuid[@"phoneType"]);

// MARK: - 网络信息
NetworkService *network = [[NetworkService alloc] init];

NSString *networkType = [network networkTypeDetail];
NSString *isVpn = [network isVpn];
NSString *isProxied = [network proxied];

[network wifiInfoWithCompletion:^(NSDictionary *wifiDict) {
    NSString *ssid = wifiDict[@"ssid"];
    NSLog(@"已连接 WIFI：%@", ssid);
}];

// MARK: - 存储信息
StorageService *storage = [[StorageService alloc] init];
NSLog(@"总内存：%@ GB", [storage ramTotal]);
NSLog(@"可用内存：%@ GB", [storage ramCanUse]);

// MARK: - 设备信息
DeviceService *device = [[DeviceService alloc] init];
NSLog(@"屏幕分辨率：%@", [device screenResolution]);
NSLog(@"电池电量：%@%%", [device batteryLevel]);
NSLog(@"IDFA：%@", [device idfa]);

// MARK: - 设备型号
PhoneService *phone = [[PhoneService alloc] init];
NSLog(@"设备型号：%@", [phone deviceModelName]);

// MARK: - 越狱检测
BrokenService *broken = [[BrokenService alloc] init];
NSLog(@"是否越狱：%@", [broken brokenCrackStatus]);
```

## 📋 API 概览

### SystemService 方法列表

| 方法 | 返回类型 | 说明 |
|------|----------|------|
| `getDeviceInfoAsync(uuid:completion:)` | 异步 | 异步获取完整设备信息（包含 WiFi 信息） |
| `getDeviceInfoAsyncWithOutUuid(completion:)` | 异步 | 异步获取设备信息（包含 WiFi 信息，不含 UUID） |
| `getDeviceInfoDataSyncWithOutWifi(uuid:)` | `[String: String]` | 同步获取设备信息（不含 WiFi 信息，带 UUID） |
| `getDeviceInfoDataSyncWithOutWifi()` | `[String: String]` | 同步获取设备信息（不含 WiFi 信息，不含 UUID） |

### 方法选择建议

- **需要 WiFi 信息**：使用异步方法（`getDeviceInfoAsync` 或 `getDeviceInfoAsyncWithOutUuid`）
- **不需要 WiFi 信息，追求快速响应**：使用同步方法（`getDeviceInfoDataSyncWithOutWifi`）
- **需要 UUID 标识**：选择带 `uuid:` 参数的方法

## 📊 返回数据字段说明

`SystemService` 返回的字典包含以下字段：

| 字段 | 类型 | 说明 | 示例值 |
|------|------|------|--------|
| uuid | String | 用户传入的 UUID（仅异步方法带 uuid 参数时返回） | "user-123" |
| screenResolution | String | 屏幕分辨率（物理像素） | "1170-2532" |
| screenWidth | String | 屏幕宽度（逻辑像素） | "390" |
| screenHeight | String | 屏幕高度（逻辑像素） | "844" |
| cpuNum | String | CPU 核心数 | "6" |
| ramTotal | String | 总内存（GB） | "6.000000" |
| ramCanUse | String | 可用内存（GB） | "2.500000" |
| batteryLevel | String | 电池电量百分比（0-100） | "85" |
| charged | String | 是否充电中 | "true" / "false" |
| totalBootTime | String | 系统启动时长（毫秒） | "3600000" |
| totalBootTimeWake | String | 系统运行时长（毫秒） | "1800000" |
| defaultLanguage | String | 默认语言 | "zh" |
| defaultTimeZone | String | 默认时区标识 | "Asia/Shanghai" |
| idfa | String | IDFA（广告标识符） | "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" |
| idfv | String | IDFV（应用标识符） | "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" |
| phoneMark | String | 设备名称 | "iPhone" |
| phoneType | String | 设备型号名称 | "iPhone 15 Pro" |
| systemVersions | String | iOS 版本号 | "17.0" |
| versionCode | String | 应用版本号 | "1.0.0" |
| network | String | 网络类型数字编码（0-5） | "1" |
| wifiName | String | WIFI 名称（仅异步方法返回） | "MyWiFi" |
| wifiBssid | String | WIFI BSSID（仅异步方法返回） | "aa:bb:cc:dd:ee:ff" |
| isvpn | String | 是否使用 VPN | "true" / "false" |
| lastBootTime | String | 上次启动时间戳（毫秒） | "1698000000000" |
| proxied | String | 是否使用代理 | "true" / "false" |
| simulated | String | 是否在模拟器运行 | "true" / "false" |
| debugged | String | 是否处于调试状态 | "true" / "false" |
| screenBrightness | String | 屏幕亮度百分比（0-100） | "80" |
| cashTotal | String | 总磁盘空间（GB） | "128.000000" |
| cashCanUse | String | 可用磁盘空间（GB） | "64.500000" |
| rooted | String | 是否越狱 | "true" / "false" |

**注意**：同步方法返回 `[String: String]`，异步方法返回 `[String: Any]`。

## 📶 网络类型编码

| 编码 | 网络类型 | 说明 |
|------|----------|------|
| 0 | Unknown / 不可达 | 无法获取网络信息 |
| 1 | WiFi | 已连接 WIFI 网络 |
| 2 | 2G | 2G 移动网络 |
| 3 | 3G | 3G 移动网络 |
| 4 | 4G | 4G/LTE 移动网络 |
| 5 | 5G | 5G 移动网络 |

## 📱 设备类型编码

| 编码 | 设备类型 | 说明 |
|------|----------|------|
| 0 | 其他 | 未知设备类型 |
| 1 | Mac | Mac 系列设备 |
| 2 | iPad | iPad 系列设备 |
| 3 | iPhone | iPhone 系列设备 |

## ⚠️ 注意事项

### 权限要求

#### WIFI 信息获取
需要在 `Info.plist` 中添加以下权限：

```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

对于 iOS 13+，还需要添加位置权限（WIFI 信息获取需要）：

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>需要获取 WIFI 信息以提供更好的服务</string>
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>需要获取 WIFI 信息以提供更好的服务</string>
```

#### IDFA 获取
iOS 14+ 需要请求用户授权，库会自动处理权限请求流程。首次调用时会弹出系统权限对话框。

### 异步调用

以下方法为异步调用，需要通过闭包/回调获取结果：

- `SystemService.getDeviceInfoAsync(uuid:completion:)` - 获取完整设备信息（包含 WiFi）
- `SystemService.getDeviceInfoAsyncWithOutUuid(completion:)` - 获取设备信息（包含 WiFi，不含 UUID）
- `NetworkService.wifiInfo(completion:)` - 获取 WIFI 信息

**注意**：异步方法会在主线程回调结果，可直接更新 UI。

### 同步方法 vs 异步方法

| 特性 | 同步方法 | 异步方法 |
|------|----------|----------|
| WiFi 信息 | ❌ 不包含 | ✅ 包含 |
| 执行时间 | < 10ms | 100-500ms（WiFi 获取耗时） |
| 主线程影响 | 可能阻塞 | ✅ 不阻塞 |
| 返回类型 | `[String: String]` | `[String: Any]` |
| 使用场景 | 追求快速响应、不需要 WiFi 信息 | 需要完整信息、需要 WiFi 信息 |

### 设备兼容性

| iOS 版本 | WIFI 信息获取方式 | 说明 |
|----------|------------------|------|
| iOS 14.0+ | `NEHotspotNetwork` | 使用系统新 API，更稳定 |
| iOS 10.0-13.x | `CNCopyCurrentNetworkInfo` | 需要特殊权限，可能不稳定 |

### 性能说明

- 同步方法：执行时间 < 10ms，可直接在主线程调用
- 异步方法：WIFI 信息获取可能需要 100-500ms，已在后台线程执行
- 内存占用：< 1MB，无内存泄漏风险

## 🐛 常见问题

### 1. WIFI 信息获取失败？

**可能原因：**
- 未添加必要的权限配置
- 设备未连接 WIFI 网络
- 用户拒绝了位置权限
- 在模拟器上测试（模拟器不支持 WIFI 信息获取）

**解决方案：**
- 检查 `Info.plist` 中的权限配置
- 确保在真机上测试
- 确保设备已连接 WIFI 网络
- 检查用户是否授予了位置权限

### 2. IDFA 返回 "null"？

**可能原因：**
- iOS 14+ 用户拒绝了追踪权限
- 设备限制了广告追踪

**解决方案：**
- 首次调用时会弹出权限请求，引导用户同意
- 在设置中检查"限制广告追踪"是否开启

### 3. 越狱检测结果不准确？

**说明：**
- 越狱检测基于多种检测方式，可能存在误判
- 检测方式包括：文件检测、符号链接检测、进程检测等

**建议：**
- 结合业务场景综合判断
- 不要仅依赖单一检测结果

### 4. 内存/磁盘信息不准确？

**说明：**
- 内存信息基于系统 API，可能存在一定延迟
- 磁盘信息包含系统保留空间

**建议：**
- 定期刷新数据以获取最新状态
- 关注可用空间而非总空间

### 5. 同步方法和异步方法返回类型不同？

**说明：**
- 同步方法返回 `[String: String]`，因为 WiFi 信息是同步获取的
- 异步方法返回 `[String: Any]`，因为包含异步获取的 WiFi 信息

**建议：**
- 使用时注意类型转换
- 异步方法回调中可以直接访问所有字段

## 📝 更新日志

### 0.1.5
- ✨ 将 WIFI 信息获取改为异步方式
- 🔄 新增 `getDeviceInfoAsync` 和 `getDeviceInfoAsyncWithOutUuid` 异步方法
- 🔄 新增 `getDeviceInfoDataSyncWithOutWifi` 同步方法
- 🚀 优化 iOS 14+ WIFI 信息获取方式
- 📚 完善文档和示例代码

### 0.1.4
- 🐛 修复越狱检测的误判问题
- 📱 支持最新设备型号（iPhone 16 系列）
- ⚡ 优化内存占用

## 🏗️ Example 工程

克隆仓库后，在 `Example` 目录执行 `pod install`，再打开 `SwiftSystemService.xcworkspace` 运行示例。

```bash
git clone https://github.com/yanwenbo78201/SwiftSystemService.git
cd SwiftSystemService/Example
pod install
open SwiftSystemService.xcworkspace
```

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

## 📄 许可

基于 [MIT License](LICENSE)。

## 👨‍💻 作者

yanwenbo78201 · yanwenbo78201@gmail.com

## 🔗 相关链接

- [GitHub 仓库](https://github.com/yanwenbo78201/SwiftSystemService)
- [CocoaPods 页面](https://cocoapods.org/pods/SwiftSystemService)
- [问题反馈](https://github.com/yanwenbo78201/SwiftSystemService/issues)

## 🌟 Star History

如果这个项目对你有帮助，请给个 Star ⭐️