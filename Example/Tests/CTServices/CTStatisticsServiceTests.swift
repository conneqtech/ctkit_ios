//
//  CTStatisticsServiceTests.swift
//  ctkit_Tests
//
//  Created by Gert-Jan Vercauteren on 20/06/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import XCTest
import RxBlocking
import Mockingjay

@testable import ctkit

class CTStatisticsServiceTests: XCTestCase {

    override func setUp() {
        let _ = try! CTUserService().login(email: "paul@conneqtech.com", password: "test").toBlocking().first()!
    }

    func test_gets_week_stats() {
        let results = try! CTStatisticsService().fetchWeek(withBikeId: 1295, andDayInWeek: Date()).toBlocking().first()!
        XCTAssertEqual(results.count, 7, "Has 7 days for a week")
    }

    func test_gets_day_stats() {
        let results = try! CTStatisticsService().fetchDay(withBikeId: 1295, andDay: Date()).toBlocking().first()!
        XCTAssertEqual(results.count, 24, "Has 24hours for a day")
    }
}
