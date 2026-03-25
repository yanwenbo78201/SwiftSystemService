//
//  BrokenService.swift
//  SwiftSystemService_Example
//
//  Created by Computer  on 25/03/26.
//  Copyright © 2026 CocoaPods. All rights reserved.
//

import UIKit
import Darwin

@objcMembers
public class BrokenService: NSObject {
    private static let CYDIAPath = "/Applications/Cydia.app"
    private static let CrackFILEPaths = [
        "/Applications/RockApp.app",
        "/Applications/Icy.app",
        "/usr/sbin/sshd",
        "/usr/bin/sshd",
        "/usr/libexec/sftp-server",
        "/Applications/WinterBoard.app",
        "/Applications/SBSettings.app",
        "/Applications/MxTube.app",
        "/Applications/IntelliScreen.app",
        "/Library/MobileSubstrate/DynamicLibraries/Veency.plist",
        "/Library/MobileSubstrate/DynamicLibraries/LiveClock.plist",
        "/private/var/lib/apt",
        "/private/var/stash",
        "/System/Library/LaunchDaemons/com.ikey.bbot.plist",
        "/System/Library/LaunchDaemons/com.saurik.Cydia.Startup.plist",
        "/private/var/tmp/cydia.log",
        "/private/var/lib/cydia",
        "/etc/clutch.conf",
        "/var/cache/clutch.plist",
        "/etc/clutch_cracked.plist",
        "/var/cache/clutch_cracked.plist",
        "/var/lib/clutch/overdrive.dylib",
        "/var/root/Documents/Cracked/",
    ]

    public func brokenCrackStatus() -> String {
        var brokenCrakType: Int = 0
        if Self.brokenCrakCocydia() == true {
            brokenCrakType += 3
        }
        if Self.brokenCrakGolanaccessFiles() == true {
            brokenCrakType += 2
        }
        if Self.brokenCrakPlist() == true {
            brokenCrakType += 2
        }
        if Self.brokenCrakSymbolic() == true {
            brokenCrakType += 2
        }
        if Self.brokenCrakFilesExist() == true {
            brokenCrakType += 2
        }
        return brokenCrakType >= 3 ? "true" : "false"
    }

    private static func brokenCrakCocydia() -> Bool {
        if FileManager.default.fileExists(atPath: CYDIAPath) == true {
            return true
        } else {
            return false
        }
    }

    private static func brokenCrakGolanaccessFiles() -> Bool {
        var brokenCrakType: Bool = false
        for (_, filePath) in CrackFILEPaths.enumerated() {
            if FileManager.default.fileExists(atPath: filePath) == true {
                brokenCrakType = true
                break
            }
        }
        return brokenCrakType
    }

    private static func brokenCrakPlist() -> Bool {
        guard let exepath = Bundle.main.executablePath else { return true }
        guard let plistPaths = Bundle.main.infoDictionary else { return true }
        if FileManager.default.fileExists(atPath: exepath) == false {
            return true
        }
        if plistPaths.keys.count <= 0 {
            return true
        }
        return false
    }

    private static func brokenCrakSymbolic() -> Bool {
        var deviceStats = stat()
        if lstat("/Applications", &deviceStats) != 0 {
            if (deviceStats.st_mode & S_IFLNK) != 0 {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }

    private static func brokenCrakFilesExist() -> Bool {
        if let executablePath = Bundle.main.executablePath {
            if FileManager.default.fileExists(atPath: executablePath) == true {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
}
