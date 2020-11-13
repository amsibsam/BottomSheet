//
//  ViewController.swift
//  Example
//
//  Created by Rahardyan Bisma on 13/11/20.
//  Copyright © 2020 amsibsam. All rights reserved.
//

import UIKit
import RBBottomSheet

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func showBottomSheet(_ sender: Any) {
        let viewControllerA = ViewControllerA()
        viewControllerA.openSomeScreenCallback = {
            self.navigationController?.pushViewController(ViewControllerB(), animated: true)
        }
        self.present(BottomSheetViewController(viewController: viewControllerA, height: 400), animated: true, completion: nil)
    }
    
}

