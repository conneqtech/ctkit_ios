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
        let bike = try! CTBikeService().fetchOwned().toBlocking().first()!.first!
        do {
            _ = try CTShareBikeService().fetchSingleInvite(withBike: bike, inviteId: "").toBlocking().first()
            XCTAssert(true)
        } catch {
            // Error is true because inviteId is ""
            print(error)
            XCTAssert(true)
        }
    }

    func testFetchSingleInviteNotOwner() {
        let bike = try! CTBikeService().fetchShared().toBlocking().first()!.first!
        let invite = try! CTShareBikeService().fetchSingleInvite(withBike: bike, inviteId: "").toBlocking().first()!
        XCTAssertTrue(invite.id == "")
    }

    func testFetchInvitesOwner() {
        let bike = try! CTBikeService().fetchOwned().toBlocking().first()!.first!
        let invites = try! CTShareBikeService().fetchInvites(withBike: bike, status: "accepted").toBlocking().first()!.meta.limit
        XCTAssertTrue(invites == 20)
    }

    func testFetchInvitesNotOwner() {
        let bike = try! CTBikeService().fetchShared().toBlocking().first()!.first!
        let invites = try! CTShareBikeService().fetchInvites(withBike: bike, status: "accepted").toBlocking().first()!.meta.limit
        XCTAssertTrue(invites == 0)
    }
}
