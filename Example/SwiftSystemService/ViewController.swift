//
//  ViewController.swift
//  SwiftSystemService
//
//  Created by crazyLuobo on 03/24/2026.
//  Copyright (c) 2026 crazyLuobo. All rights reserved.
//

import UIKit
import SwiftSystemService

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print(SystemService.getDeviceInfo(uuid: "85242112121212"))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

