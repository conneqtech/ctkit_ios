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
                    
                    do {
                        let _ = try CTUserService().create(email: "", password: "").toBlocking().first()
                    } catch {
                        if let ctError = error as? CTErrorProtocol {
                            expect(ctError.type) == .validation
                        } else {
                            expect("error") == "ctError"
                        }
                    }
                }
                
//                it("Handles the error when the username is not a valid email address") {
//                    let url = Bundle(for: type(of: self)).url(forResource: "invalidEmailAndPassword", withExtension: "json")!
//                    let data = try! Data(contentsOf: url)
//                    self.stub(http(.post, uri: "/user"), jsonData(data, status: 422))
//
//                    do {
//                        let callToTest = try CTUserService().create(email: "NOT_VALID_EMAIL", password: "").toBlocking().first()
//                    } catch {
//                        print(error)
//                        expect(error.localizedDescription) == "error"
//                    }
//
//                }
//
//                //TODO: Handles the error when the user already exists
//                it("handles the error when the user already exists") {
//                    let url = Bundle(for: type(of: self)).url(forResource: "userAlreadyExists", withExtension: "json")!
//                    let data = try! Data(contentsOf: url)
//                    self.stub(http(.post, uri: "/user"), jsonData(data, status: 422))
//
//                    do {
//                        let callToTest = try CTUserService().create(email: "EMAIL_THAT_EXISTS", password: "A_PASSWORD").toBlocking().first()
//                    } catch {
//                        print(error)
//                    }
//                }
//
//                //TODO: Creates a user successfully and returns the created user
//                it("creates a user succesfully and returns the created user") {
//                    let url = Bundle(for: type(of: self)).url(forResource: "user", withExtension: "json")!
//                    let data = try! Data(contentsOf: url)
//                    self.stub(http(.post, uri: "/user"), jsonData(data))
//
//                    let callToTest = try! CTUserService().create(email: "user@login.bike", password: "test").toBlocking().first()
//                  
//                }
//
//            describe("createAndLogin") {
//                //TODO: Handles the error when the username and password field are empty
//                it("Handles the error when the username and password field are empty") {
//                    let url = Bundle(for: type(of: self)).url(forResource: "createValidationError", withExtension: "json")!
//                    let data = try! Data(contentsOf: url)
//                    
//                    self.stub(http(.post, uri: "/user"), jsonData(data, status: 422))
//                    
//                    do {
//                        let callToTest = try CTUserService().createAndLogin(email: "", password: "").toBlocking().first()
//                    } catch {
//                        print(error)
//                    }
//                }
//        
//                it("Handles the error when the username is not a valid email address") {
//                    let url = Bundle(for: type(of: self)).url(forResource: "invalidEmailAndPassword", withExtension: "json")!
//                    let data = try! Data(contentsOf: url)
//                    self.stub(http(.post, uri: "/user"), jsonData(data, status: 422))
//
//                    do {
//                        let callToTest = try CTUserService().createAndLogin(email: "NOT_VALID_EMAIL", password: "").toBlocking().first()
//                    } catch {
//                        print(error)
//                    }
//                    
//                }
//
//                //TODO: Handles the error when the user already exists
//                it("handles the error when the user already exists") {
//                    let url = Bundle(for: type(of: self)).url(forResource: "userAlreadyExists", withExtension: "json")!
//                    let data = try! Data(contentsOf: url)
//                    self.stub(http(.post, uri: "/user"), jsonData(data, status: 422))
//                    
//                    do {
//                         let callToTest = try CTUserService().create(email: "EMAIL_THAT_EXISTS", password: "A_PASSWORD").toBlocking().first()
//                    } catch {
//                        print(error)
//                    }
//
//
//
//                }
//
//
//                //TODO: Creates a user successfully and returns the created user
//
//
//
//                //TODO: Creates a user and requests an access token and sets up a session (CTBike gets filled)
//
//
//                //TODO: Creates account through create and login, then does the same thing again
//                //Should not be possible but is probably gonna fail in current setup
//            }
//        }
            }
        }
    }
}

