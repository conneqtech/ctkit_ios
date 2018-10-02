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
import RxSwift

class AccountViewController: UIViewController {

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        if CTUserService().hasActiveSession() {
            let subscription = CTUserService().fetchCurrentUser().subscribe (onNext: { user in
                print(user.email)
                print(user.firstName)
            }, onError: { error in
                print(error)
            })
            
            disposeBag.insert(subscription)
        }
    }
    
    @IBAction func signOut(_ sender: Any) {
        CTUserService().logout()
        
        var loadingViewController: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loadingViewController")
        self.present(loadingViewController, animated: true, completion: nil)
    }
}
