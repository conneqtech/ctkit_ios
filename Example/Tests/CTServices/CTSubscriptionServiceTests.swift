//
//  CTSubscriptionServiceTests.swift
//  ctkit_Tests
//
//  Created by Inigo Llamosas on 17/01/2021.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import XCTest

@testable import ctkit

class CTSubscriptionServiceTests: XCTestCase {

    override class func setUp() {
        _ = try! CTUserService().login(email: "paul@conneqtech.com", password: "test").toBlocking().first()!
    }

    override class func tearDown() {
        CTUserService().logout()
    }

    func testClaimOwner() {
        let bike = try! CTBikeService().fetchOwned().toBlocking().first()!.first!
        do {
           _ = try CTSubscriptionService().claim(withBike: bike).toBlocking().first()
        } catch {
            print(error)
            XCTFail()
        }
    }
}
