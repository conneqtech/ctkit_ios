//
//  CTShareBikeServiceTests.swift
//  ctkit_Tests
//
//  Created by Inigo Llamosas on 15/01/2021.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import XCTest

@testable import ctkit

class CTShareBikeServiceTests: XCTestCase {

    override class func setUp() {
        let _ = try! CTUserService().login(email: "paul@conneqtech.com", password: "test").toBlocking().first()!
    }

    override class func tearDown() {
        CTUserService().logout()
    }

    func testFetchSingleInviteOwner() {
        
    }
    
    func testFetchSingleInviteNotOwner() {
        
    }
    
    func testFetchInvitesOwner() {
//
    }

    func testFetchInvitesNotOwner() {
        
    }
}
