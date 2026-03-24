
import UIKit
import Darwin

@objcMembers
public class TimeService: NSObject {
    
    public func totalBootTime() -> String {
        var bootTime = timeval()
        var timevalSize = MemoryLayout<timeval>.stride
        var mib: [Int32] = [CTL_KERN, KERN_BOOTTIME]
        var nowTime = timeval()
        var currentZone = timezone()
        
        gettimeofday(&nowTime, &currentZone)
        _ = sysctl(&mib, UInt32(mib.count), &bootTime, &timevalSize, nil, 0)
        
        var resultBootTime: Int = 0
        if bootTime.tv_sec != 0 {
            resultBootTime = (nowTime.tv_sec - bootTime.tv_sec) * 1000
            resultBootTime += Int((nowTime.tv_usec - bootTime.tv_usec)) / 1000
        }
        return "\(resultBootTime)"
    }
    
    public func totalBootTimeWake() -> String {
        return "\(Int(ProcessInfo.processInfo.systemUptime * 1000))"
    }
    
    public func lastBootTime() -> String {
        if let totalBootTimeMs = Double(totalBootTime()) {
            let bootSecondsInterval = totalBootTimeMs / 1000.0
            let bootTimeDate = Date(timeIntervalSinceNow: (-bootSecondsInterval))
            let lastBootStamp = bootTimeDate.timeIntervalSince1970 * 1000
            return "\(Int(lastBootStamp))"
        } else {
            return "0"
        }
    }
}

