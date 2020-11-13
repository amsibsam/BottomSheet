//
//  File.swift
//  BottomSheet
//
//  Created by Rahardyan Bisma on 13/11/20.
//  Copyright © 2020 amsibsam. All rights reserved.
//

import Foundation
import UIKit

open class SheetContentViewController : UIViewController {
    public var dismissCallback: (() -> Void)?
    public var backToPreviousContentCallback: (() -> Void)?
    public var changeContentCallback: ((UIViewController, CGFloat) -> Void)?
}
