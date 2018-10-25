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
                    self.stub(http(.post, uri: "/user"), jsonData(data, status: 422))
                    
                    let callToTest = try! CTUserService().create(email: "", password: "").toBlocking().first()
                    
                    if let unWrappedCallToTest = callToTest {
                        switch unWrappedCallToTest {
                        case .failure(let error):
                            expect(error.code) == 422
                            expect(error.translationKey) == "error.api.fields-invalid"
                            expect(error.description) == "One or more supplied fields are invalid"
                        default:
                            fail("We expect errors")
                        }
                    } else {
                        fail("We expect to unwrap")
                    }
                }
                
                it("Handles the error when the username is not a valid email address") {
                    let url = Bundle(for: type(of: self)).url(forResource: "invalidEmailAndPassword", withExtension: "json")!
                    let data = try! Data(contentsOf: url)
                    self.stub(http(.post, uri: "/user"), jsonData(data, status: 422))
                    
                    let callToTest = try! CTUserService().create(email: "NOT_VALID_EMAIL", password: "").toBlocking().first()
                    
                    if let unWrappedCallToTest = callToTest {
                        switch unWrappedCallToTest {
                        case .failure(let error):
                            expect(error.code) == 422
                            expect(error.translationKey) == "error.api.validation-failed"
                            expect(error.description) == "Failed Validation"
                        default:
                            fail("We expect errors")
                        }
                    } else {
                        fail("We expect to unwrap")
                    }
                }
                
                //TODO: Handles the error when the user already exists
                it("handles the error when the user already exists") {
                    let url = Bundle(for: type(of: self)).url(forResource: "userAlreadyExists", withExtension: "json")!
                    let data = try! Data(contentsOf: url)
                    self.stub(http(.post, uri: "/user"), jsonData(data, status: 406))
                    
                    let callToTest = try! CTUserService().create(email: "EMAIL_THAT_EXISTS", password: "A_PASSWORD").toBlocking().first()
                    
                    if let unWrappedCallToTest = callToTest {
                        switch unWrappedCallToTest {
                        case .failure(let error):
                            expect(error.code) == 406
                            expect(error.translationKey) == "error.api.username.alreadytaken"
                            expect(error.description) == "Failed validation"
                        default:
                            fail("We expect errors")
                        }
                    } else {
                        fail("We expect to unwrap")
                    }
                }
                
                //TODO: Creates a user successfully and returns the created user
                it("creates a user succesfully and returns the created user") {
                    var userResponse:CTResult<CTUserModel, CTBasicError>?
                    let url = Bundle(for: type(of: self)).url(forResource: "user", withExtension: "json")!
                    let data = try! Data(contentsOf: url)
                    self.stub(http(.post, uri: "/user"), jsonData(data))
                    
                    let callToTest = try! CTUserService().create(email: "user@login.bike", password: "test").toBlocking().first()
                    
                    if let unWrappedCallToTest = callToTest {
                        switch unWrappedCallToTest {
                        case .success(let response) :
                            expect(response.id).toNot(equal(0))
                        default:
                            fail("We expect the user to be created")
                }
            }
            
            describe("createAndLogin") {
                //TODO: Handles the error when the username and password field are empty
                
                
                //TODO: Handles the error when the username is not a valid email address
                
                //TODO: Handles the error when the user already exists
                
                //TODO: Creates a user successfully and returns the created user
                
                //TODO: Creates a user and requests an access token and sets up a session (CTBike gets filled)
            }
        }
    }
}

