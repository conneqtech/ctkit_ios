//
//  CreateAccountViewController.swift
//  ctkit_Example
//
//  Created by Gert-Jan Vercauteren on 02/10/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import ctkit
import RxSwift

class CreateAccountViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func createAccount(_ sender: Any) {
        let subscription = CTUserService().createAndLogin(
            withEmail: self.emailTextField.text!,
            password: self.passwordTextField.text!,
            agreedToPrivacyStatement: true
            ).subscribe { event in
                switch event {
                case .next(let _):
                    let navViewController: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "accountNavigationController")
                    self.present(navViewController, animated: true, completion: nil)
                case .error(let error):
                    print(error)
                case .completed:
                    print("Completed")
                }
            }
        
        disposeBag.insert(subscription)
    }
}
