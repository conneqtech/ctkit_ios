//
//  CTUserServiceTests.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 24/09/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
import ctkit

import RxBlocking

class CTUserServiceTests: QuickSpec {
    
    override func spec() {
        describe("Login") {
            it("logs in with correct username/password") {
                let userService = CTUserService()
                let subscription = userService.login(email: "gert-jan@test.com", password: "testpass").subscribe { event in
                    switch event {
                    case .next(let value):
                        print(value.displayName)
                    case .error(let error):
                        print(error)
                    case .completed:
                        print("Completed")
                    }
                }
                
                subscription.dispose()
            }
        }
    }
}

