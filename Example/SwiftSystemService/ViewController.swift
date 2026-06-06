//
//  ViewController.swift
//  SwiftSystemService
//
//  Created by crazyLuobo on 03/24/2026.
//  Copyright (c) 2026 crazyLuobo. All rights reserved.
//

import UIKit
import SwiftSystemService
import FYLocationObjc
import AppTrackingTransparency
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
            LocationManager.shared().requestLocation(required: true) { result, coorde, success, alert in
                SystemService.getDeviceInfoAsync(uuid: "sdfsdfsfsdfsdfsdf") { deviceInfo in
                    print(deviceInfo)
                }
            }
        }
        // Do any additional setup after loading the view, typically from a nib.
      
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

