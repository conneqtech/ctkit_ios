//
//  CTLinkedUserServiceTests.swift
//  ctkit_Example
//
//  Created by Gert-Jan Vercauteren on 25/05/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import XCTest
import Mockingjay
import RxSwift
import RxBlocking


@testable import ctkit

class CTShareBikeServiceTests: XCTestCase {

    func testCreateInviteLink() {
        let dummyUser = try! CTUserService().login(email: "geotech+insurance@conneq.tech", password: "testpass").toBlocking().first()!
        let subject = try! CTShareBikeService().createInviteCode(withBikeId: 1296).toBlocking().first()!

        print(subject)
    }

    func testDeleteInviteLink() {
        let dummyUser = try! CTUserService().login(email: "geotech+insurance@conneq.tech", password: "testpass").toBlocking().first()!
        let subject = try! CTShareBikeService().deleteInviteCode(withBikeId: 1296).toBlocking().materialize()

        let code = try! CTShareBikeService().fetchInviteCode(withBikeId: 1296).toBlocking().first()!
        print(code)
    }

}

