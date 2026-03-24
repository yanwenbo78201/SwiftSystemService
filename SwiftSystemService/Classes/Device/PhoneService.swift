
import UIKit

// 设备型号识别相关功能
@objcMembers
public class PhoneService: NSObject {
    
    // 获取设备型号名称
    public func deviceModelName() -> String {
        var telephoniMudelName = utsname()
        uname(&telephoniMudelName)
        let mudelType = Mirror(reflecting: telephoniMudelName.machine)
        let telefoniMudel = mudelType.children.reduce("") { telefoniMudel, element in
            guard let value = element.value as? Int8, value != 0 else { return telefoniMudel }
            return telefoniMudel + String(UnicodeScalar(UInt8(value)))
        }
        
        return mapDeviceModel(telefoniMudel)
    }
    
    // 获取设备类型数字编码
    public func deviceTypeNumber() -> String {
        let modelName = deviceModelName()
        
        if modelName.hasPrefix("iPhone") {
            return "3"
        } else if modelName.hasPrefix("iPad") {
            return "2"
        } else if modelName.hasPrefix("iMac") || modelName.hasPrefix("Mac") {
            return "1"
        } else {
            return "0"
        }
    }
    
    // 获取设备UA类型
    public func deviceUAType() -> String {
        let modelName = deviceModelName()
        
        if modelName.hasPrefix("iPhone") {
            return "Mobile"
        } else if modelName.hasPrefix("iPad") {
            return "Tablet"
        } else if modelName.hasPrefix("iMac") || modelName.hasPrefix("Mac") {
            return "pc"
        } else {
            return "unknown"
        }
    }
    
    // 映射设备型号
    private func mapDeviceModel(_ model: String) -> String {
        // 模拟器
        if model == "i386" || model == "x86_64" || model == "arm64" {
            return "iPhone Simulator"
        }
        
        // iPhone系列
        let iphoneModels: [String: String] = [
            "iPhone5,1": "iPhone 5", "iPhone5,2": "iPhone 5",
            "iPhone5,3": "iPhone 5c", "iPhone5,4": "iPhone 5c",
            "iPhone6,1": "iPhone 5s", "iPhone6,2": "iPhone 5s",
            "iPhone7,1": "iPhone 6 Plus", "iPhone7,2": "iPhone 6",
            "iPhone8,1": "iPhone 6s", "iPhone8,2": "iPhone 6s Plus", "iPhone8,4": "iPhone SE",
            "iPhone9,1": "iPhone 7", "iPhone9,2": "iPhone 7 Plus", "iPhone9,4": "iPhone 7 Plus",
            "iPhone10,1": "iPhone 8", "iPhone10,4": "iPhone 8",
            "iPhone10,2": "iPhone 8 Plus", "iPhone10,5": "iPhone 8 Plus",
            "iPhone10,3": "iPhone X", "iPhone10,6": "iPhone X",
            "iPhone11,8": "iPhone XR", "iPhone11,2": "iPhone XS", "iPhone11,6": "iPhone XS Max",
            "iPhone12,1": "iPhone 11", "iPhone12,3": "iPhone 11 Pro", "iPhone12,5": "iPhone 11 Pro Max", "iPhone12,8": "iPhone SE 2",
            "iPhone13,1": "iPhone 12 mini", "iPhone13,2": "iPhone 12", "iPhone13,3": "iPhone 12 Pro", "iPhone13,4": "iPhone 12 Pro Max",
            "iPhone14,4": "iPhone 13 mini", "iPhone14,5": "iPhone 13", "iPhone14,2": "iPhone 13 Pro", "iPhone14,3": "iPhone 13 Pro Max", "iPhone14,6": "iPhone SE 3",
            "iPhone14,7": "iPhone 14", "iPhone14,8": "iPhone 14 Plus",
            "iPhone15,2": "iPhone 14 Pro", "iPhone15,3": "iPhone 14 Pro Max",
            "iPhone15,4": "iPhone 15", "iPhone15,5": "iPhone 15 Plus",
            "iPhone16,1": "iPhone 15 Pro", "iPhone16,2": "iPhone 15 Pro Max",
            "iPhone17,3": "iPhone 16", "iPhone17,4": "iPhone 16 Plus",
            "iPhone17,1": "iPhone 16 Pro", "iPhone17,2": "iPhone 16 Pro Max","iPhone17,5": "iPhone 16e",
            "iPhone18,1": "iPhone 17 Pro", "iPhone18,2": "iPhone 17 Pro Max",
            "iPhone18,3": "iPhone 17", "iPhone18,4": "iPhone Air","iPhone18,5":"iPhone 17e"

        ]
        
        if let iPhoneName = iphoneModels[model] {
            return iPhoneName
        }
        
        // iPad系列
        if model == "iPad1,1" { return "iPad" }
        if ["iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4"].contains(model) { return "iPad 2" }
        if ["iPad2,5", "iPad2,6", "iPad2,7"].contains(model) { return "iPad mini" }
        if ["iPad3,1", "iPad3,2", "iPad3,3"].contains(model) { return "iPad 3" }
        if ["iPad3,4", "iPad3,5", "iPad3,6"].contains(model) { return "iPad 4" }
        if ["iPad4,1", "iPad4,2", "iPad4,3"].contains(model) { return "iPad Air" }
        if ["iPad4,4", "iPad4,5", "iPad4,6"].contains(model) { return "iPad mini 2" }
        if ["iPad4,7", "iPad4,8", "iPad4,9"].contains(model) { return "iPad mini 3" }
        if ["iPad5,1", "iPad5,2"].contains(model) { return "iPad mini 4" }
        if ["iPad11,1", "iPad11,2"].contains(model) { return "iPad mini 5" }
        if ["iPad14,1", "iPad14,2"].contains(model) { return "iPad mini 6" }
        if ["iPad5,3", "iPad5,4"].contains(model) { return "iPad Air 2" }
        if ["iPad6,3", "iPad6,4"].contains(model) { return "iPad Pro (9.7-inch)" }
        if ["iPad6,7", "iPad6,8"].contains(model) { return "iPad Pro (12.9-inch)" }
        if ["iPad6,11", "iPad6,12"].contains(model) { return "iPad 5" }
        if ["iPad7,1", "iPad7,2"].contains(model) { return "iPad Pro 2 (12.9-inch)" }
        if ["iPad7,3", "iPad7,4"].contains(model) { return "iPad Pro (10.5-inch)" }
        if ["iPad7,5", "iPad7,6"].contains(model) { return "iPad 6" }
        if ["iPad7,11", "iPad7,12"].contains(model) { return "iPad 7" }
        if ["iPad11,6", "iPad11,7"].contains(model) { return "iPad 8" }
        if ["iPad12,1", "iPad12,2"].contains(model) { return "iPad 9" }
        if ["iPad11,3", "iPad11,4"].contains(model) { return "iPad Air 3" }
        if ["iPad13,1", "iPad13,2"].contains(model) { return "iPad Air 4" }
        if ["iPad13,6", "iPad13,7"].contains(model) { return "iPad Air 5" }
        if ["iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4"].contains(model) { return "iPad Pro (11-inch)" }
        if ["iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8"].contains(model) { return "iPad Pro 3 (12.9-inch)" }
        if ["iPad8,9", "iPad8,10"].contains(model) { return "iPad Pro 2 (11-inch)" }
        if ["iPad8,11", "iPad8,12"].contains(model) { return "iPad Pro 4 (12.9-inch)" }
        if ["iPad13,4", "iPad13,5", "iPad13,6", "iPad13,7"].contains(model) { return "iPad Pro 3 (11-inch)" }
        if ["iPad13,8", "iPad13,9", "iPad13,10", "iPad13,11"].contains(model) { return "iPad Pro 5 (12.9-inch)" }
        
        if model.hasPrefix("iPad") { return "iPad" }
        if model.hasPrefix("iPhone") { return "iPhone" }
        
        // Apple TV
        if model == "AppleTV2,1" { return "Apple TV 2" }
        if model == "AppleTV3,1" { return "Apple TV 3" }
        if model == "AppleTV3,2" { return "Apple TV 3 (2013)" }
        
        return model
    }
}
