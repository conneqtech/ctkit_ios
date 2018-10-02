//
//  AccountViewController.swift
//  ctkit_Example
//
//  Created by Gert-Jan Vercauteren on 02/10/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import ctkit

class AccountViewController: UIViewController {
    
    override func viewDidLoad() {
        print(CTUserService().hasActiveSession())
        print(CTUserService().getActiveUserId())
    }
    
}
