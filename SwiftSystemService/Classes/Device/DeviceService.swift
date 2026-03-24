

import UIKit
import CoreTelephony
import Darwin
import AppTrackingTransparency
import AdSupport

// 系统状态相关功能
@objcMembers
public class DeviceService: NSObject {
    
    public func idfa() -> String {
        var deviceIDFA = "null"
        
        if #available(iOS 14.0, *) {
            let semaphore = DispatchSemaphore(value: 0)
            
            ATTrackingManager.requestTrackingAuthorization { status in
                if status == .authorized {
                    deviceIDFA = ASIdentifierManager.shared().advertisingIdentifier.uuidString
                }
                semaphore.signal()
            }
            
            semaphore.wait()
        } else {
            deviceIDFA = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        }
        
        return deviceIDFA
    }
    
    
    // 获取屏幕分辨率
    public func screenResolution() -> String {
        let screenScale = UIScreen.main.scale
        let width = Int(UIScreen.main.bounds.size.width * screenScale)
        let height = Int(UIScreen.main.bounds.size.height * screenScale)
        return "\(width)-\(height)"
    }
    
    // 获取屏幕亮度
    public func screenBrightness() -> String {
        let brightness = UIScreen.main.brightness
        
        if brightness < 0 || brightness > 1 {
            return "-1"
        }
        return "\(Int(brightness * 100))"
    }
    
    // 获取CPU核心数
    public func cpuNum() -> String {
        let processorCount = ProcessInfo.processInfo.processorCount
        return "\(processorCount)"
    }
    
    // 获取电池电量
    public func batteryLevel() -> String {
        UIDevice.current.isBatteryMonitoringEnabled = true
        let batteryLevel = UIDevice.current.batteryLevel
        
        if batteryLevel > 0.0 {
            return "\(Int(batteryLevel * 100))"
        }
        return "-1"
    }
    
    // 获取充电状态
    public func charged() -> String {
        let device = UIDevice.current
        device.isBatteryMonitoringEnabled = true
        
        if device.batteryState == .charging || device.batteryState == .full {
            return "true"
        }
        return "false"
    }
    
    // 获取默认语言
    public func defaultLanguage() -> String {
        let preferredLanguages = Locale.preferredLanguages
        
        if preferredLanguages.count > 0 {
            let defaultLanguage = preferredLanguages[0]
            if defaultLanguage.count > 0 {
                let languages = defaultLanguage.components(separatedBy: "-")
                return languages.count > 0 ? languages[0] : "null"
            }
        }
        return "null"
    }
    
    // 获取调试状态
    public func debugStatus() -> String {
        var debugInfo = kinfo_proc()
        var debugMid: [Int32] = [CTL_KERN, KERN_PROC, KERN_PROC_PID, getpid()]
        debugInfo.kp_proc.p_flag = 0
        var debugSize = MemoryLayout<kinfo_proc>.size
        let result = sysctl(&debugMid, UInt32(debugMid.count), &debugInfo, &debugSize, nil, 0)
        
        if result > 0 {
            return "true"
        } else {
            return (debugInfo.kp_proc.p_flag & P_TRACED) != 0 ? "true" : "false"
        }
    }
}
