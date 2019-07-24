//
//  CTActivityCenterServiceTests.swift
//  ctkit_Tests
//
//  Created by Gert-Jan Vercauteren on 23/07/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import XCTest
import RxBlocking
import Mockingjay

@testable import ctkit

class CTActivityCenterServiceTests: XCTestCase {

    override func setUp() {
        let _ = try! CTUserService().login(email: "paul@conneqtech.com", password: "test").toBlocking().first()!
    }

    func test_get_all_activity() {
        let results = try! CTActivityCenterService().fetchAll().toBlocking().first()!
        print(results)
    }
}
