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
import Mockingjay
import RxSwift

import RxBlocking

class CTUserServiceTests: QuickSpec {
    
    let bag = DisposeBag()
    
    override func spec() {
        describe("CTUserServiceTests") {
            it("refreshes an accesstoken") {
                let oauth : [String: Any] = [
                    "access_token": "1234",
                    "expires_in": 3600,
                    "scope": "",
                    "token_type": "Bearer"
                ]
                
                self.stub(uri("/oauth"), json(oauth))
                
                let body = ["id" : 10,
                            "username": "test@test.com",
                            "name":"Gert-Jan"
                    ] as [String : Any]
                self.stub(uri("/user/me"), json(body))
                
                let result = try! CTUserService().login(email: "test@test.com", password: "test").toBlocking().first()

            }
        }
    }
}

