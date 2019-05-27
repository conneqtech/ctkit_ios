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

class CTLinkedUserServiceTests: XCTestCase {

    func testFetchLinkedUsers() {
        let dummyUser = try! CTUserService().login(email: "gert-jan@conneqtech.com", password: "testpass").toBlocking().first()!
        let subject = try! CTShareBikeService().fetchAcceptedLinkedUsers(withBikeId: 14).toBlocking().first()!

        print(subject.data.count)
    }

}

