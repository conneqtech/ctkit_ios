//
//  ViewController.swift
//  ctkit
//
//  Created by jookes on 09/20/2018.
//  Copyright (c) 2018 jookes. All rights reserved.
//

import UIKit
import ctkit
import RxSwift

class ViewController: UIViewController {
    
    let userService = CTUserService()
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    var subscriptions = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(CTUserService().getActiveUserId())
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func login(_ sender: Any) {
        let subscription = self.userService.login(
            username: self.emailTextField.text!,
            password: self.passwordTextfield.text!)
            .subscribe { event in
                switch event {
                case .next(let value):
                    let navViewController: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "accountNavigationController")
                    self.present(navViewController, animated: true, completion: nil)
                case .error(let error):
                    print(error)
                    CTUserService().logout()
                case .completed:
                    print("Completed")
                }
            }
        self.subscriptions.insert(subscription)
    }
}

// Put this piece of code anywhere you like
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
