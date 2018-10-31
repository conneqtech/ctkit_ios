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
                    self.stub(http(.post, uri: "/user"), json(Resolver().getJSONForResource(name: "createValidationError"), status: 422))
                    
                    do {
                        let _ = try CTUserService().create(email: "", password: "", agreedToPrivacyStatement: true).toBlocking().first()
                    } catch {
                        if let ctError = error as? CTErrorProtocol {
                            expect(ctError.type) == .validation
                            expect(ctError.translationKey) == "api.error.validation-failed"
                            
                            if let validationError = ctError as? CTValidationError {
                                expect(validationError.validationMessages).to(haveCount(2))
                                //TODO: Check actual messages
                            }
                        } else {
                            expect("error") == "ctError"
                        }
                    }
                }
                
                it("Handles the error when the username is not a valid email address") {
                    self.stub(http(.post, uri: "/user"), json(Resolver().getJSONForResource(name: "invalidEmailAndPassword"), status: 422))

                    do {
                        let _ = try CTUserService().create(email: "NOT_VALID_EMAIL", password: "validPasswordThatIsLongEnough").toBlocking().first()
                    } catch {
                        do {
                            let _ = try CTUserService().create(email: "", password: "", agreedToPrivacyStatement: true).toBlocking().first()
                        } catch {
                            if let ctError = error as? CTErrorProtocol {
                                expect(ctError.type) == .validation
                                expect(ctError.translationKey) == "api.error.validation-failed"
                                
                                if let validationError = ctError as? CTValidationError {
                                    expect(validationError.validationMessages).to(haveCount(2))
                                    //TODO: Check actual messages
                                }
                            } else {
                                expect("error") == "ctError"
                            }
                        }
                    }
                }

                it("Handles the error when the user already exists") {
                    self.stub(http(.post, uri: "/user"), json(Resolver().getJSONForResource(name: "userAlreadyExists"), status: 422))

                    do {
                        let _ = try CTUserService().create(email: "EMAIL_THAT_EXISTS", password: "A_PASSWORD").toBlocking().first()
                    } catch {
                        if let ctError = error as? CTErrorProtocol {
                            expect(ctError.type) == .validation
                            expect(ctError.translationKey) == "api.error.validation-failed"
                            
                            if let validationError = ctError as? CTValidationError {
                                print(validationError.validationMessages)
                                expect(validationError.validationMessages).to(haveCount(1))
                                
                                let messageToTest = validationError.validationMessages[0]
                                expect(messageToTest.type) == "usernameAlreadyTaken"
                                expect(messageToTest.originalMessage) == "User already exists"
                            }
                        } else {
                            expect("error") == "ctError"
                        }
                    }
                }
                
                it("Creates a user succesfully and returns the created user") {
                    var jsonDict = Resolver().getJSONForResource(name: "user")
                    
                    let randomUsername = "\(Int.random(in: 0 ... 1000))@login.bike"
                    jsonDict["username"] = randomUsername
                    
                    self.stub(http(.post, uri: "/user"), json(jsonDict, status: 200))

                    let callToTest = try! CTUserService().create(email: randomUsername, password: "A_VALID_PASSWORD").toBlocking().first()
                    
                    if let user = callToTest {
                        expect(user.email) == randomUsername
                    } else {
                        expect("can unwrap") == "did not unwrap"
                    }
                }
            }
            
            describe("createAndLogin") {
                
            }
        }
    }
}

