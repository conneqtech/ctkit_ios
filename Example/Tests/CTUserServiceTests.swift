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
            describe("create") {
                it("Handles the error when the username and password field are empty") {
                    let url = Bundle(for: type(of: self)).url(forResource: "createValidationError", withExtension: "json")!
                    let data = try! Data(contentsOf: url)
//                    self.stub(http(.post, uri: "/user"), jsonData(data, status: 422))
                    
                    let callToTest = try! CTUserService().create(email: "", password: "").toBlocking().first()
                    
                    if let unWrappedCallToTest = callToTest {
                        switch unWrappedCallToTest {
                        case .failure(let error):
                            expect(error.code) == 422
                            expect(error.translationKey) == "error.api.invalidfields"
                            expect(error.description) == "A validation error occured"
                        default:
                            fail("We expect errors")
                        }
                    } else {
                        fail("We expect to unwrap")
                    }
                }
            }
        }
    }
}

