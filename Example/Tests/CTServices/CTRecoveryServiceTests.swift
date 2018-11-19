//
//  CTRecoveryServiceTests.swift
//  ctkit_Tests
//
//  Created by Gert-Jan Vercauteren on 01/11/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation

import Foundation
import Quick
import Nimble
import Mockingjay
@testable import ctkit

class CTRecoveryServiceTests: QuickSpec {
    
    override func spec () {
        describe("Password recovery start") {
            it("Should fail password recovery with invalid input") {
                let subjectUnderTest = CTUserRecoveryService()
                
                do {
                    let _ = try subjectUnderTest.recoverUser(email: "RANDOM_STRING").toBlocking().first()
                } catch {
                    if let ctError = error as? CTErrorProtocol {
                        expect(ctError.type) == .validation
                        expect(ctError.translationKey) == "api.error.validation-failed"
                        
                        if let validationError = ctError as? CTValidationError {
                            expect(validationError.validationMessages).to(haveCount(1))
                            let message = validationError.validationMessages[0]
                            
                            expect(message.field) == "email"
                            expect(message.originalMessage) == "The input is not a valid email address. Use the basic format local-part@hostname"
                            expect(message.translatableKey) == "dummy"
                        }
                    } else {
                        expect("error") == "ctError"
                    }
                }
            }
            
            it("Should start password recovery with valid input") {
                let subjectUnderTest = CTUserRecoveryService()
            
                let result = try! subjectUnderTest.recoverUser(email: "fake-email@example.com").toBlocking().first()
                expect(result) == ["success": true]
            }
        }
        
        describe("Pasword recovery finish") {
            it("Should fail finishing password recovery with invalid password") {
                let subjectUnderTest = CTUserRecoveryService()
                do {
                    let _ = try subjectUnderTest.finishPasswordRecovery(password: "test", resetHash: "HASH_PLS").toBlocking().first()
                } catch {
                    if let ctError = error as? CTErrorProtocol {
                        expect(ctError.type) == .validation
                        expect(ctError.translationKey) == "api.error.validation-failed"
                        
                        if let validationError = ctError as? CTValidationError {
                            expect(validationError.validationMessages).to(haveCount(1))
                            let message = validationError.validationMessages[0]
                            
                            expect(message.field) == "password"
                            expect(message.originalMessage) == "The input is less than 5 characters long"
                            expect(message.translatableKey) == "dummy"
                        }
                    }
                }
            }
            
            it("Should fail finishing password recovery with invalid hash and valid password") {
                let subjectUnderTest = CTUserRecoveryService()
                do {
                    let _ = try subjectUnderTest.finishPasswordRecovery(password: "thispasswordmatchesrequirements", resetHash: "HASH_PLS").toBlocking().first()
                } catch {
                    if let ctError = error as? CTErrorProtocol {
                        expect(ctError.type) == .basic
                        expect(ctError.translationKey) == "api.error.user.recover.invalidtoken"
                    }
                }
            }
            
            it("Should succeed finishing password recovery with valid password and hash") {
                let subjectUnderTest = CTUserRecoveryService()
                
                self.stub(http(.post, uri: "/user/recover"), json(["success":true] ,status: 201))
                
                let result = try! subjectUnderTest.finishPasswordRecovery(
                    password: "testpass",
                    resetHash: "8647a005420d3f3308e025e0f293d5d3cec695f1bd296d9562b2bcb70dc7330a").toBlocking().first()
                expect(result) == ["success": true]
            }
        }
    }
}
