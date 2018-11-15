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
        describe("fetch") {
            it("Handles the error when the theftcase does not exist") {
                self.stub(http(.get, uri: "/theft-case/2"), json(Resolver().getJSONForResource(name: "theftCaseIdNotFound"),status: 404))
                
                do {
                    try _ = CTTheftCaseService().fetch(withCaseId: 2).toBlocking().first()
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
                self.stub(http(.get, uri: "theft-case/0"), json(Resolver().getJSONForResource(name: "theftcase"), status: 200))
                let callToTest = try! CTTheftCaseService().fetch(withCaseId: 0).toBlocking().first()
                if let theftCase = callToTest {
                    expect(theftCase.id).to(equal(0))
                }
            }
        }
        
        describe("create") {
            
        }
        
        describe("patch") {
            
        }
    }
    
}
