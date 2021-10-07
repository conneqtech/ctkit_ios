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

//    override func setUpWithError() throws {
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//    }
//
//    override func tearDownWithError() throws {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//    }

    func testExample() throws {
        CTKit.shared.idsAuthManager = CTIdsAuthManager(idsTokenApiUrl: "idsTokenApiUrl", idsLoginApiUrl: "idsLoginApiUrl", idsRedirectUri: "idsRedirectUri")
        
        CTKit.shared.idsAuthManager?.getTokenIdForLogout(callBack: { didAlreadyHaveTokenId in
            
            XCTAssert(didAlreadyHaveTokenId == false)
            
        })
        
        
        let credentialResponse = CTCredentialResponse(accessToken: "",
                                                      refreshToken: nil,
                                                      expiresIn: 1,
                                                      scope: nil,
                                                      tokenType: "",
                                                      tokenId: "myTokenId")
        
        CTKit.shared.authManager.saveTokenResponse(credentialResponse)
        
        CTKit.shared.idsAuthManager?.getTokenIdForLogout(callBack: { didAlreadyHaveTokenId in
            
            XCTAssert(didAlreadyHaveTokenId == true)
            
        })
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
