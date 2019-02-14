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
    let userService = CTUserService()

    override func viewDidLoad() {
        if self.userService.hasActiveSession() {
            self.userService.fetchCurrentUser().subscribe (onNext: { _ in
//                print(result.email)
//                print(result.firstName)
            }).disposed(by: disposeBag)
        }
    }

    func getBikes() {

    }

    @IBAction func signOut(_ sender: Any) {
        self.userService.logout()

        let loadingViewController: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loadingViewController")
        self.present(loadingViewController, animated: true, completion: nil)
    }
}
