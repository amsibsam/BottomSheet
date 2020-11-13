//
//  ViewControllerA.swift
//  Example
//
//  Created by Rahardyan Bisma on 13/11/20.
//  Copyright © 2020 amsibsam. All rights reserved.
//

import UIKit
import BottomSheet

class ViewControllerA: SheetContentViewController {
    var openSomeScreenCallback: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func openSomeScreen(_ sender: Any) {
        openSomeScreenCallback?()
        dismissCallback?()
    }
    
    @IBAction func changeBottomSheetContent(_ sender: Any) {
        changeContentCallback?(ViewControllerA2(), 200)
    }
}
