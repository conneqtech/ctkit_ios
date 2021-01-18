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

//    func testFetchSingleInviteOwner() {
//        let bike = try! CTBikeService().fetchOwned().toBlocking().first()!.first!
//
//        let invite = try! CTShareBikeService().fetchSingleInvite(withBikeId: bike.id, inviteId: "").toBlocking().first()!
//        XCTAssertTrue(invite.linkedUserId == 0)
//    }
//
//    func testFetchSingleInviteNotOwner() {
//        let bike = try! CTBikeService().fetchShared().toBlocking().first()!.first!
//
//    }

    func testFetchInvitesOwner() {
        let bike = try! CTBikeService().fetchOwned().toBlocking().first()!.first!
        let invites = try! CTShareBikeService().fetchInvites(withBikeId: bike.id, status: "accepted").toBlocking().first()!.meta.limit
        XCTAssertTrue(invites == 20)

    }

    func testFetchInvitesNotOwner() {
        let bike = try! CTBikeService().fetchShared().toBlocking().first()!.first!
        let invites = try! CTShareBikeService().fetchInvites(withBikeId: bike.id, status: "accepted").toBlocking().first()!.meta.limit
        XCTAssertTrue(invites == 0)
    }
}
