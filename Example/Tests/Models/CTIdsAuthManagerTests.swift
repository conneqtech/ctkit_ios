//
//  CTIdsAuthManagerTests.swift
//  ctkit_Tests
//
//  Created by Inigo Llamosas on 07/10/2021.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import XCTest

@testable import ctkit


class CTIdsAuthManagerTests: XCTestCase {


    func testIfUnexistentTokenidShouldNotRefresh() {
        CTKit.shared.idsAuthManager = CTIdsAuthManager(idsTokenApiUrl: "idsTokenApiUrl", idsLoginApiUrl: "idsLoginApiUrl", idsRedirectUri: "idsRedirectUri")
        let expectation = XCTestExpectation(description: "getTokenIdForLogout")
        var result: Bool? = nil

        let credentialResponse = CTCredentialResponse(accessToken: "",
                                                      refreshToken: nil,
                                                      expiresIn: 1,
                                                      scope: nil,
                                                      tokenType: "",
                                                      tokenId: "myTokenId")
        CTKit.shared.authManager.saveTokenResponse(credentialResponse)
        CTKit.shared.idsAuthManager?.getTokenIdForLogout(callBack: { didAlreadyHaveTokenId in
            result = didAlreadyHaveTokenId
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 10.0)
        XCTAssert(result == true)
    }
}
