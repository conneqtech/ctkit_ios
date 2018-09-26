//
//  ViewController.swift
//  ctkit
//
//  Created by jookes on 09/20/2018.
//  Copyright (c) 2018 jookes. All rights reserved.
//

import UIKit
import ctkit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let subscription = CTUserService().login(username: "jens+11@conneqtech.com", password: "testpass").subscribe { event in
            switch event {
            case .next(let value):
                print("DONE")
                self.getBikes()
                print(value)
            case .error(let error):
                print(error)
            case .completed:
                print("Completed")
            }
        }
        
//        subscription.dispose()
        // Do any additional setup after loading the view, typically from a nib.
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }

}

