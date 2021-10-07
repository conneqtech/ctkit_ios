//
//  CTKitActiveSessionTests.swift
//  ctkit_Tests
//
//  Created by Gert-Jan Vercauteren on 24/10/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import XCTest

@testable import ctkit

class CTKitActiveSessionTests: XCTestCase {

    var authManager: CTAuthManager!

    override func setUp() {
        let config = CTApiConfig(withBaseUrl: "", clientId: "", clientSecret: "", grantType: .clientCredentials)
        authManager = CTAuthManager(withConfig: config)
        CTKit.shared.logout()
    }

    func test_has_active_session_userdefaults () {
        CTKit.shared.credentialSaveLocation = .userDefaults

        let tokenResponse = CTCredentialResponse(accessToken: "test", refreshToken: "test", expiresIn: 8600, scope: "", tokenType: "bearer")
        authManager.saveTokenResponse(tokenResponse)

        XCTAssertTrue(CTKit.shared.hasActiveSession())
    }

    func test_has_active_session_keychain () {
        CTKit.shared.credentialSaveLocation = .keychain

        let tokenResponse = CTCredentialResponse(accessToken: "test", refreshToken: "test", expiresIn: 8600, scope: "", tokenType: "bearer")
        authManager.saveTokenResponse(tokenResponse)

        XCTAssertTrue(CTKit.shared.hasActiveSession())
    }

    func test_has_active_session_expired_userdefaults () {
        CTKit.shared.credentialSaveLocation = .userDefaults

        let tokenResponse = CTCredentialResponse(accessToken: "test", refreshToken: "test", expiresIn: -8600, scope: "", tokenType: "bearer")
        authManager.saveTokenResponse(tokenResponse)

        XCTAssertFalse(CTKit.shared.hasActiveSession())
    }

    func test_has_active_session_expired_keychain () {
        CTKit.shared.credentialSaveLocation = .keychain

        let tokenResponse = CTCredentialResponse(accessToken: "test", refreshToken: "test", expiresIn: -8600, scope: "", tokenType: "bearer")
        authManager.saveTokenResponse(tokenResponse)

        XCTAssertFalse(CTKit.shared.hasActiveSession())
    }

    func test_has_active_session_logout_keychain () {
        CTKit.shared.credentialSaveLocation = .keychain

        let tokenResponse = CTCredentialResponse(accessToken: "test", refreshToken: "test", expiresIn: 8600, scope: "", tokenType: "bearer")
        authManager.saveTokenResponse(tokenResponse)

        XCTAssertTrue(CTKit.shared.hasActiveSession())
        CTKit.shared.logout()
        XCTAssertFalse(CTKit.shared.hasActiveSession())
    }

    func test_has_active_session_logout_userdefaults () {
        CTKit.shared.credentialSaveLocation = .keychain

        let tokenResponse = CTCredentialResponse(accessToken: "test", refreshToken: "test", expiresIn: 8600, scope: "", tokenType: "bearer")
        authManager.saveTokenResponse(tokenResponse)

        XCTAssertTrue(CTKit.shared.hasActiveSession())
        CTKit.shared.logout()
        XCTAssertFalse(CTKit.shared.hasActiveSession())
    } 
}
