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

    override func setUp() {
        CTKit.shared.idsAuthManager = CTIdsAuthManager(idsTokenApiUrl: "idsTokenApiUrl", idsLoginApiUrl: "idsLoginApiUrl", idsRedirectUri: "idsRedirectUri")
    }

    override func tearDown() {
        CTKit.shared.idsAuthManager = nil
    }
    
    func testIfUnexistentTokenidShouldNotRefresh() {
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
    
    func testIfUnexistentTokenidShouldRefresh() {
        
        KeychainSwift().delete(CTKit.TOKEN_ID)
        UserDefaults.standard.removeObject(forKey: CTKit.TOKEN_ID)
        
        let expectation = XCTestExpectation(description: "getTokenIdForLogout")
        var result: Bool? = nil

        CTKit.shared.idsAuthManager?.getTokenIdForLogout(callBack: { didAlreadyHaveTokenId in
            result = didAlreadyHaveTokenId
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 10.0)
        XCTAssert(result == false)
    }
}
