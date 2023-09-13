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

    var dayComponent = DateComponents()
    let theCalendar = Calendar.current
    
    override func setUp() {
        let _ = try! CTUserService().login(email: "paul@conneqtech.com", password: "test").toBlocking().first()!
    }

    func test_gets_week_stats() {
        
        self.dayComponent.day = 6
        guard let oneWeekLater = theCalendar.date(byAdding: dayComponent, to: Date()) else { return }
        let results = try! CTStatisticsService().fetchAll(withBikeId: 2229, type: .daily, from: Date(), till: oneWeekLater).toBlocking().first()!
        XCTAssertEqual(results.count, 7, "Has 7 days for a week")
    }

    func test_gets_day_stats() {
        
        self.dayComponent.day = 1
        self.dayComponent.hour = -1
        guard let oneDayLater = theCalendar.date(byAdding: dayComponent, to: Date()) else { return }
        let results = try! CTStatisticsService().fetchAll(withBikeId: 2229, type: .hourly, from: Date(), till: oneDayLater).toBlocking().first()!
        XCTAssertEqual(results.count, 24, "Has 24hours for a day")
    }
}
