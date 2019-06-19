//
//  CTBikeStateServiceTests.swift
//  ctkit_Tests
//
//  Created by Gert-Jan Vercauteren on 19/06/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import XCTest
import RxBlocking
import Mockingjay

@testable import ctkit

class CTBikeStateServiceTests: XCTestCase {

    func test_fetch_bikeAllNull() {
        let stubResponse: [String:Any?] = [
            "powered_on": nil,
            "ecu_locked": nil,
            "erl_locked": nil,
            "battery_percentage": nil,
            "charging":nil,
            "last_full_charge":nil
        ]

        self.stub(http(.get, uri: "/bike/1/state"), json(stubResponse, status: 200))
        let result = try! CTBikeStateService().fetchState(withBikeId: 1).toBlocking().first()!

        XCTAssertNil(result.isPoweredOn)
        XCTAssertNil(result.isDigitalLockLocked)
        XCTAssertNil(result.isPhysicalLockLocked)
        XCTAssertNil(result.batteryPercentage)
        XCTAssertNil(result.isCharging)
        XCTAssertNil(result.lastFullChargeDate)
    }

    func test_fetch_bikeAllFilled() {
        let boolValues = true
        let stubResponse: [String:Any?] = [
            "powered_on": boolValues,
            "ecu_locked": boolValues,
            "erl_locked": boolValues,
            "battery_percentage": 90,
            "charging": boolValues,
            "last_full_charge": Date().toAPIDate()
        ]

        self.stub(http(.get, uri: "/bike/1/state"), json(stubResponse, status: 200))
        let result = try! CTBikeStateService().fetchState(withBikeId: 1).toBlocking().first()!

        XCTAssertTrue(result.isPoweredOn!)
        XCTAssertTrue(result.isDigitalLockLocked!)
        XCTAssertTrue(result.isPhysicalLockLocked!)
        XCTAssertNotNil(result.batteryPercentage)
        XCTAssertTrue(result.isCharging!)
        XCTAssertNotNil(result.lastFullChargeDate)
    }
}
