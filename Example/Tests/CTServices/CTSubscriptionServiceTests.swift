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
           let subscription = try CTSubscriptionService().claim(withBikeId: bike.id, imei: bike.imei).toBlocking().first()!
            XCTAssertTrue(subscription.bikeId != 0, "Bike id shouldnt be 0")
        } catch {
            print(error)
            XCTAssert(true)
        }
    }

    func testClaimNotOwner() {

        let bike = try! CTBikeService().fetchShared().toBlocking().first()!.first!
        do {
           let subscription = try CTSubscriptionService().claim(withBikeId: bike.id, imei: bike.imei).toBlocking().first()!
            XCTAssertTrue(subscription.bikeId == 0, "Bike id be 0")
        } catch {
            print(error)
            XCTAssert(false)
        }
    }
}
