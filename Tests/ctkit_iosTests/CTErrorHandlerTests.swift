//
//  CTErrorHandlerTests.swift
//  ctkit_Tests
//
//  Created by Gert-Jan Vercauteren on 19/10/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble

@testable import ctkit

class CTErrorHandlerTests: QuickSpec {

    override func spec() {
        describe("OAuth errors") {
            it("Handles 400") {
                let subjectUnderTest = CTErrorHandler()
                let result = subjectUnderTest.handle(withJSONData: Resolver().getJSONForResource(name: "400-error"))

                expect(result.type) == .basic
                expect(result.translationKey) == "api.error.400.bad-request"
            }

            it("Handles 422 validation") {
                let subjectUnderTest = CTErrorHandler()
                let result = subjectUnderTest.handle(withJSONData: Resolver().getJSONForResource(name: "validation-error"))

                expect(result.type) == .validation
                expect(result.translationKey) == "api.error.validation-failed"

                if let validationError = result as? CTValidationError {
                    expect(validationError.validationMessages.count) == 2
                } else {
                    expect("validation") == "wrong error type"
                }
            }
        }
    }
}
