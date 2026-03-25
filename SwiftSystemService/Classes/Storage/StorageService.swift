

import UIKit
import Darwin

@objcMembers
public class StorageService: NSObject {
    
    public func ramTotal() -> String {
        let systemPhysicalMemory = ProcessInfo.processInfo.physicalMemory
        var totalMemory = (Double(systemPhysicalMemory) / 1024.0) / 1024.0
        
        let reservedMemory = 256
        let reservedMemoryRemainder = Int(totalMemory) % reservedMemory
        if reservedMemoryRemainder >= reservedMemory / 2 {
            totalMemory = Double(Int(totalMemory) - reservedMemoryRemainder + 256)
        } else {
            totalMemory = Double(Int(totalMemory) - reservedMemoryRemainder)
        }
        
        if totalMemory <= 0 {
            totalMemory = -1
        }
        
        return String(format: "%.6f", totalMemory / 1024.0)
    }
        
    public func ramCanUse() -> String {
        let hostPort = mach_host_self()
        var hostSize = mach_msg_type_number_t(MemoryLayout<vm_statistics_data_t>.size / MemoryLayout<integer_t>.size)
        var pageSize: vm_size_t = 0
        
        if host_page_size(hostPort, &pageSize) != KERN_SUCCESS {
            return "-1"
        }
        
        var vmStat = vm_statistics_data_t()
        let result = withUnsafeMutablePointer(to: &vmStat) { pointer in
            pointer.withMemoryRebound(to: integer_t.self, capacity: Int(hostSize)) { reboundedPointer in
                host_statistics(hostPort, HOST_VM_INFO, reboundedPointer, &hostSize)
            }
        }
        
        if result != KERN_SUCCESS {
            return "-1"
        }
        
        let virtualMemoryUsed = UInt(vmStat.active_count + vmStat.inactive_count + vmStat.wire_count) * pageSize
        print(virtualMemoryUsed)
        
        let totalMemorySize = Double(ProcessInfo.processInfo.physicalMemory) / 1024.0 / 1024.0
        let useMemorySize = Double(virtualMemoryUsed) / 1024.0 / 1024.0
        let canMemoryUseSize = (totalMemorySize - useMemorySize) / 1024.0
        return String(format: "%.6f", canMemoryUseSize)
    }
        

    public func cashTotal() -> String {
        if let diskAttributes = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory()),
           let totalDiskSize = diskAttributes[.systemSize] as? Int, totalDiskSize > 0 {
            let transGNum = Double(totalDiskSize) / (1024.0 * 1024.0 * 1024.0)
            return String(format: "%.6f", transGNum)
        }
        return "-1"
    }
    
    public func cashCanUse() -> String {
        if let diskAttributes = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory()),
           let freeDiskSize = diskAttributes[.systemFreeSize] as? Int, freeDiskSize > 0 {
            let transGNum = Double(freeDiskSize) / (1024.0 * 1024.0 * 1024.0)
            return String(format: "%.6f", transGNum)
        }
        return "-1"
    }
    
}
