//
//  LoadingViewController.swift
//  ctkit_Example
//
//  Created by Gert-Jan Vercauteren on 02/10/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import ctkit

class LoadingViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
        var navViewController: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginNavigationController")
        if CTUserService().getActiveUserId() != -1 {
            navViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "accountNavigationController")
        }
        
        self.present(navViewController, animated: false, completion: nil)
    }
}
