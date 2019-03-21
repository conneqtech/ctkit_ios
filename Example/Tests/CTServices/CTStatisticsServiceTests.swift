//
//  CTStatisticsServiceTests.swift
//  ctkit_Tests
//
//  Created by Daan van der Jagt on 19/11/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
import ctkit
import Mockingjay
import RxSwift
import XCTest

import RxBlocking

class CTStatisticsServiceTests: XCTestCase {
    
    override func setUp() {
        let _ = try! CTUserService().login(email: "paul@conneqtech.com", password: "test").toBlocking().first()!
    }
    
    func testFetchHourlyStats() {
        let startDateString = "2019-03-21T00:00:00"
        let endDateString = "2019-03-21T23:59:59"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"

        
        let subjectUnderTest = try! CTStatisticsService().fetchAll(withBikeId: 743,
                                                              type: "hourly",
                                                              from: dateFormatter.date(from:startDateString)!,
                                                              till: dateFormatter.date(from:endDateString)!).toBlocking().first()!
        
        XCTAssertEqual(subjectUnderTest.count, 24)
    }
    
    func testDailyStats() {
        let startDateString = "2019-03-20T00:00:00"
        let endDateString = "2019-03-21T23:59:59"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        
        let subjectUnderTest = try! CTStatisticsService().fetchAll(withBikeId: 743,
                                                                   type: "daily",
                                                                   from: dateFormatter.date(from:startDateString)!,
                                                                   till: dateFormatter.date(from:endDateString)!).toBlocking().first()!
        
        XCTAssertEqual(subjectUnderTest.count, 2)
    }
    
    func testMonthlyStats() {
        let startDateString = "2019-01-01T00:00:00"
        let endDateString = "2019-03-31T23:59:59"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        
        let subjectUnderTest = try! CTStatisticsService().fetchAll(withBikeId: 743,
                                                                   type: "monthly",
                                                                   from: dateFormatter.date(from:startDateString)!,
                                                                   till: dateFormatter.date(from:endDateString)!).toBlocking().first()!
        
        XCTAssertEqual(subjectUnderTest.count, 3)
    }
    
}
