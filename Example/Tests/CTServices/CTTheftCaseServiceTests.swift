//
//  CTTheftCaseServiceTests.swift
//  ctkit_Tests
//
//  Created by Daan van der Jagt on 15/11/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
import ctkit
import Mockingjay
import RxSwift

import RxBlocking

class CTTheftCaseServiceTests:QuickSpec {
    override func spec() {
        beforeEach {
            self.stub(http(.get, uri: "/user/me"), json(Resolver().getJSONForResource(name: "user"), status: 200))
            let _ = try! CTUserService().fetchCurrentUser().toBlocking().first()
            expect(CTUserService().getActiveUserId()) == 47
        }
        
        describe("fetch") {
            it("Handles the error when the theftcase does not exist") {
                self.stub(http(.get, uri: "/theft-case/2"), json(Resolver().getJSONForResource(name: "theftCaseIdNotFound"),status: 404))
                
                do {
                    let _ = try CTTheftCaseService().fetch(withCaseId: 2).toBlocking().first()
                } catch {
                    if let ctError = error as? CTErrorProtocol {
                        expect(ctError.type) == .basic
                        expect(ctError.translationKey) == "api.error.404.not-found"
                    } else {
                        expect("error") == "ctError"
                    }
                }
            }
            
            it("Handles the error when the bikeId doesn't exist") {
                self.stub(http(.get, uri: "/theft-case"), json(Resolver().getJSONForResource(name: "bikeIdNotFound"), status: 404))
                do {
                    let _ = try CTTheftCaseService().fetchAll(withBikeId: 0).toBlocking().first()
                } catch {
                    if let ctError = error as? CTErrorProtocol {
                        expect(ctError.type) == .basic
                        expect(ctError.translationKey) == "api.error.404.not-found"
                    } else {
                        expect("error") == "ctError"
                    }
                }
            }
            
            
            it("Succesfully fetches the theftcase") {
                self.stub(http(.get, uri: "/theft-case/0"), json(Resolver().getJSONForResource(name: "theftcase"), status: 200))
                let callToTest = try! CTTheftCaseService().fetch(withCaseId: 0).toBlocking().first()
                if let theftCase = callToTest {
                    expect(theftCase.id).to(equal(0))
                }  else {
                    expect("can unwrap") == "did not unwrap"
                }
            }
            
            it("Succesfully fetches the most recent theft-case") {
                self.stub(http(.get, uri: "/theft-case"), json(Resolver().getJSONForResource(name: "theftcase"), status: 200))
                let callToTest = try! CTTheftCaseService().fetchMostRecent(withBikeId: 0).toBlocking().first()
                if let theftCaseModel = callToTest {
                    expect(theftCaseModel.id).to(equal(0))
                } else {
                    expect("can unwrap") == "did not unwrap"
                }
            }
            
            
            it("Handles an empty array") {
                let emptyArray:[CTTheftCaseModel] = []
                self.stub(http(.get, uri: "/theft-case"), json(emptyArray))
                let callToTest = try! CTTheftCaseService().fetchAll(withBikeId: 0).toBlocking().first()
                if let emptyArray = callToTest {
                    expect(emptyArray.data.count).to(equal(0))
                } else {
                    expect("can unwrap") == "did not unwrap"
                }
            }
            
            fit("Succesfully fetches all theft-cases for a bike") {
                self.stub(http(.get, uri: "/theft-case"), json(Resolver().getJSONForResource(name: "theftcaseList"), status: 200))
                let callToTest = try! CTTheftCaseService().fetchAll(withBikeId: 0).toBlocking().first()
                if let theftCases = callToTest {
                    expect(theftCases.data.count).to(equal(7))
                } else {
                    expect("can unwrap") == "did not unwrap"
                }
            }
        }
        
        describe("create") {
            it("Handles the error when the create fails") {
                let theftCaseData = try! JSONDecoder().decode(CTTheftCaseModel.self, from: Resolver().getDataForResource(name: "theftcase"))

                self.stub(http(.post, uri: "/theft-case"), json(Resolver().getJSONForResource(name: "createTheftCaseValidationError"), status: 422))
                do {
                  _ = try CTTheftCaseService().create(theftCase: theftCaseData).toBlocking().first()
                } catch {
                    if let ctError = error as? CTErrorProtocol {
                        expect(ctError.type) == .validation
                        expect(ctError.translationKey) == "api.error.validation-failed"

                        if let validationError = ctError as? CTValidationError {
                            expect(validationError.validationMessages).to(haveCount(6))

                            let messageToTest = validationError.validationMessages[0]
                            expect(messageToTest.type) == "isEmpty"
                            expect(messageToTest.originalMessage) == "Value is required and can't be empty"
                        }
                    }
                }
            }
            
            it("Succesfully creates a theftcase") {
                self.stub(http(.post, uri: "/theft-case"), json(Resolver().getJSONForResource(name: "theftcase"), status: 201))
                let theftCaseData = Resolver().getDataForResource(name: "theftcase")
                let callToTest = try! CTTheftCaseService().create(theftCase: JSONDecoder().decode(CTTheftCaseModel.self, from: theftCaseData)).toBlocking().first()
                if let theftCase = callToTest {
                    expect(theftCase.caseNumber).toNot(beNil())
                } else {
                    expect("can unwrap") == "did not unwrap"
                }
            }
        }
        
        describe("patch") {
            it("Handles the error when the caseId doesn't exist") {
                self.stub(http(.patch, uri: "/theft-case/2"), json(Resolver().getJSONForResource(name: "theftCaseIdNotFound"), status: 404))
                do {
                    try _ = CTTheftCaseService().patchPoliceId(withCaseId: 2, policeId: "VALIDPOLICEID").toBlocking().first()
                } catch {
                    if let ctError = error as? CTErrorProtocol {
                        expect(ctError.type) == .basic
                        expect(ctError.translationKey) == "api.error.404.not-found"
                    } else {
                        expect("error") == "ctError"
                    }
                }
            }
            
            it("Handles the error when the policeId is empty") {
                self.stub(http(.patch, uri: "/theft-case/0"), json(Resolver().getJSONForResource(name: "patchPoliceIdValidationError"), status: 422))
                do {
                    try _ = CTTheftCaseService().patchPoliceId(withCaseId: 0, policeId: "").toBlocking().first()
                } catch {
                    if let ctError = error as? CTErrorProtocol {
                        expect(ctError.type) == .validation
                        expect(ctError.translationKey) == "api.error.validation-failed"
                        
                        if let validationError = ctError as? CTValidationError {
                            expect(validationError.validationMessages).to(haveCount(1))
                            
                            let messageToTest = validationError.validationMessages[0]
                            expect(messageToTest.type) == "isEmpty"
                            expect(messageToTest.originalMessage) == "Value is required and can't be empty"
                        }
                    }
                }
            }
            
            it("Succesfully patches the policeid for a case") {
                self.stub(http(.patch, uri: "/theft-case/0"), json(Resolver().getJSONForResource(name: "theftcase"), status: 200))
                let callToTest = try! CTTheftCaseService().patchPoliceId(withCaseId: 0, policeId: "SOMEVALIDPOLICEID").toBlocking().first()
                if let theftCaseModel = callToTest {
                    expect(theftCaseModel.id).to(equal(0))
                } else {
                    expect("can unwrap") == "did not unwrap"
                }
            }
        }
    }
    
}
