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
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func login(_ sender: Any) {
        let subscription = self.userService.login(
            username: self.emailTextField.text!,
            password: self.passwordTextfield.text!)
            .subscribe { event in
                switch event {
                case .next(let value):
                    print("User is logged in")
                    print(value)
                case .error(let error):
                    print(error)
                case .completed:
                    print("Completed")
                }
            }
        self.subscriptions.insert(subscription)
    }
    
    func patchUser(_ user: CTUserModel) {
        var mUser = user
        mUser.firstName = "Test"
        mUser.lastName = "User"
        print("PATCHING USER")
        
        let sub = CTUserService().patch(user: mUser).subscribe { event in
            switch event {
            case .next(let value):
                print("DONE USER")
                print(value.firstName!)
            case .error(let error):
                print(error)
            case .completed:
                print("Completed")
            }
        }
    }
    
    func getBikes() {
        let sub = CTBikeService().fetchAll().subscribe { event in
            switch event {
            case .next(let value):
                print("DONE BIKE")
                print(value)
            case .error(let error):
                print(error)
            case .completed:
                print("Completed")
            }
        }
    }
    
    func createUser() {
        let sub = CTUserService().create(email: "gert-jan+eqwerwetyrytukylkjjtdfgfgdfgwe@conneqtech.com", password: "testpass").subscribe { event in
            switch event {
            case .next(let value):
                print("DONE User")
                print(value.email)
            case .error(let error):
                print(error)
            case .completed:
                print("Completed")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
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
