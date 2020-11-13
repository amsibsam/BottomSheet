//
//  ViewControllerA2.swift
//  Example
//
//  Created by Rahardyan Bisma on 13/11/20.
//  Copyright © 2020 amsibsam. All rights reserved.
//

import UIKit
import RBBottomSheet

class ViewControllerA2: SheetContentViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func backDidTap(_ sender: Any) {
        backToPreviousContentCallback?()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
