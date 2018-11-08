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
                beforeEach {
                    CTUserService().logout()
                }
            
                it("Fails to create a user and doesn't log in") {
                    
                    self.stub(http(.post, uri: "/user"), json(Resolver().getJSONForResource(name: "userAlreadyExists"), status: 422))
                    
                    do {
                        let _ = try CTUserService().createAndLogin(email: "EMAIL_THAT_EXISTS", password: "A_PASSWORD").toBlocking().first()
                    } catch {
                        expect(CTUserService().getActiveUserId()) == -1
                        expect(CTUserService().hasActiveSession()) == false
                        
                        if let ctError = error as? CTErrorProtocol {
                            expect(ctError.type) == .validation
                            expect(ctError.translationKey) == "api.error.validation-failed"
                            
                            if let validationError = ctError as? CTValidationError {
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
                
                it("Creates a user and creates a session") {
                    self.stub(http(.post, uri: "/user"), json(Resolver().getJSONForResource(name: "user"), status: 200))
                    self.stub(http(.post, uri: "/oauth"), json(Resolver().getJSONForResource(name: "oauth-success"), status: 200))
                    self.stub(http(.get, uri: "/user/me"), json(Resolver().getJSONForResource(name: "user"), status: 200))
                    
                    let callToTest = try! CTUserService().createAndLogin(email: "user@login.bike", password: "A_VALID_PASSWORD").toBlocking().first()
                    
                    if let user = callToTest {
                        expect(user.email) == "user@login.bike"
                        expect(CTUserService().hasActiveSession()) == true
                        expect(CTUserService().getActiveUserId()) == 47
                    } else {
                        expect("can unwrap") == "did not unwrap"
                    }
                }
            }
            
            describe("fetch") {
                it("Handles the error when user is not logged in") {
                    self.stub(http(.get, uri: "/user/me"), json(Resolver().getJSONForResource(name: "userNotLoggedIn"), status: 401))
                    
                    beforeEach {
                        //Make sure user is logged out
                        CTUserService().logout()
                    }
                    
                    do {
                        try _ = CTUserService().fetchCurrentUser().toBlocking().first()
                    } catch {
                        if let ctError = error as? CTErrorProtocol {
                            expect(ctError.type) == .basic
                            expect(ctError.translationKey) == "api.error.unauthorized"
                            
                            if let validationError = ctError as? CTValidationError {
                                expect(validationError.validationMessages).to(haveCount(1))
                                
                                let messageToTest = validationError.validationMessages[0]
                                expect(messageToTest.type) == "unauthorized"
                                expect(messageToTest.originalMessage) == "User is not logged in"
                            }
                        } else {
                            expect("error") == "ctError"
                        }
                    }
                    
                }
                
                it("Succesfully returns the active user") {
                    self.stub(http(.get, uri: "/user/me"), json(Resolver().getJSONForResource(name: "user"), status: 200))
                    
                    let callToTest = try! CTUserService().fetchCurrentUser().toBlocking().first()
                    
                    if let user = callToTest {
                        expect(user.email) == "user@login.bike"
                        expect(CTUserService().hasActiveSession()) == true
                        expect(CTUserService().getActiveUserId()) == 47
                    } else {
                        expect("can unwrap") == "did not unwrap"
                    }
                }
            }
            
            describe("logout") {
                beforeEach {
                    //Ensure we start 'blank'
                    CTUserService().logout()
                }
                
                it("Destroys an active session") {
                    self.stub(http(.post, uri: "/oauth"), json(Resolver().getJSONForResource(name: "oauth-success"), status: 200))
                    self.stub(http(.get, uri: "/user/me"), json(Resolver().getJSONForResource(name: "user"), status: 200))

                    expect(CTUserService().hasActiveSession()) == false
                    expect(CTUserService().getActiveUserId()) == -1
                    
                    let _ = try! CTUserService().login(email: "user@login.bike", password: "testpassword").toBlocking().first()
                    
                    expect(CTUserService().hasActiveSession()) == true
                    expect(CTUserService().getActiveUserId()) == 47
                    
                    CTUserService().logout()
                    
                    expect(CTUserService().hasActiveSession()) == false
                    expect(CTUserService().getActiveUserId()) == -1
                }
            }
            
            describe("patch") {
                it("Patches a user") {
                    //FIXME: Needs a test to see what fields get patched
                    let url = Bundle(for: type(of: self)).url(forResource: "user", withExtension: "json")!
                    let data = try! Data(contentsOf: url)
                    let originalUserModel = try! JSONDecoder().decode(CTUserModel.self, from: data)
                    
                    var updatedUserModel = Resolver().getJSONForResource(name: "user")
                    updatedUserModel["first_name"] = "FIRSTNAME"
                    updatedUserModel["last_name"] = "LASTNAME"
                    
                    self.stub(http(.patch, uri: "/user/me"), json(updatedUserModel, status: 200))
                    
                    let callToTest = try! CTUserService().patchCurrentUser(user: originalUserModel).toBlocking().first()
                    
                    if let patchedUser = callToTest {
                        expect(patchedUser.firstName!) == "FIRSTNAME"
                        expect(patchedUser.lastName!) == "LASTNAME"
                    }
                }
            }
        }
    }
}

