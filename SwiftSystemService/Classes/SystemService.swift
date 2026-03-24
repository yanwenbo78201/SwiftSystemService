//
//  LeaveDeviceInfo.swift
//  FYDeviceSwift_Example
//
//  Created by Computer  on 12/01/26.
//  Copyright © 2026 CocoaPods. All rights reserved.
//

import UIKit

@objcMembers
public class SystemService: NSObject {
    public static func getDeviceInfo(uuid:String)->[String:Any]{
        let systemMemory = StorageService()
        let systemTime = TimeService()
        let systemNetwork = NetworkService()
        let deviceUtil = DeviceService()
        let phoneService = PhoneService()
        let infoEmpty = "null"
        var leaveBaseInfo:[String:String] = [:]
        leaveBaseInfo["uuid"] = uuid
        leaveBaseInfo["screenResolution"] = deviceUtil.screenResolution()
        leaveBaseInfo["screenWidth"] = "\(Int(UIScreen.main.bounds.size.width))"
        leaveBaseInfo["screenHeight"] = "\(Int(UIScreen.main.bounds.size.height))"
        leaveBaseInfo["cpuNum"] = deviceUtil.cpuNum()
        leaveBaseInfo["ramTotal"] = systemMemory.ramTotal()
        leaveBaseInfo["ramCanUse"] = systemMemory.ramCanUse()
        leaveBaseInfo["batteryLevel"] = "\(deviceUtil.batteryLevel())"
        leaveBaseInfo["charged"] = deviceUtil.charged()
        leaveBaseInfo["totalBootTime"] = systemTime.totalBootTime()
        leaveBaseInfo["totalBootTimeWake"] = systemTime.totalBootTimeWake()
        leaveBaseInfo["defaultLanguage"] = deviceUtil.defaultLanguage()
        leaveBaseInfo["defaultTimeZone"] = NSTimeZone.system.identifier;
        leaveBaseInfo["idfa"] = deviceUtil.idfa()
        leaveBaseInfo["idfv"] = UIDevice.current.identifierForVendor?.uuidString ?? infoEmpty
        leaveBaseInfo["phoneMark"] = UIDevice.current.name
        leaveBaseInfo["phoneType"] = phoneService.deviceModelName()
        leaveBaseInfo["systemVersions"] = UIDevice.current.systemVersion
        leaveBaseInfo["versionCode"] = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? infoEmpty
        leaveBaseInfo["network"] = systemNetwork.networkTypeNumber()
        let currentSeameWifiDict = systemNetwork.wifiInfo()
        let currentWifiSSID = currentSeameWifiDict?["ssid"] ?? infoEmpty
        let currentWifiBSSID = currentSeameWifiDict?["bssid"] ?? infoEmpty
        leaveBaseInfo["wifiName"] = currentWifiSSID
        leaveBaseInfo["wifiBssid"] = currentWifiBSSID
        leaveBaseInfo["isvpn"] = systemNetwork.isVpn()
        leaveBaseInfo["lastBootTime"] = systemTime.lastBootTime()
        leaveBaseInfo["proxied"] = systemNetwork.proxied()
        leaveBaseInfo["simulated"] = phoneService.deviceModelName().contains("Simulator") == true ? "true" : "false"
        leaveBaseInfo["debugged"] = deviceUtil.debugStatus()
        leaveBaseInfo["screenBrightness"] = deviceUtil.screenBrightness()
        leaveBaseInfo["cashTotal"] = systemMemory.cashTotal()
        leaveBaseInfo["cashCanUse"] = systemMemory.cashCanUse()
        leaveBaseInfo["rooted"] = "false"
        return leaveBaseInfo
        
    }
}
