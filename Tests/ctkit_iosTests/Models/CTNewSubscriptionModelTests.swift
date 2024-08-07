//
//  CTNewSubscriptionModelTests.swift
//  ctkit_Tests
//
//  Created by Inigo Llamosas on 26/10/2022.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import XCTest
@testable import ctkit


class CTNewSubscriptionModelTests: XCTestCase {
    
    func testDatesAreParsed() {

        let startDateString = "2022-10-26T00:00:00+0000"
        let endDateString = "2023-10-26T00:00:00+0000"

        let newSubscription = CTNewSubscriptionWrapperModel(status: CTNewSubscriptionModel(startDateString: startDateString,
                                                                                       endDateString: endDateString,
                                                                                       cancelDateString: endDateString))
        
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        XCTAssert(newSubscription.status?.startDate != nil)
        XCTAssert(newSubscription.status?.startDate == df.date(from: startDateString))
        XCTAssert(newSubscription.status?.endDate != nil)
        XCTAssert(newSubscription.status?.endDate == df.date(from: endDateString))
        XCTAssert(newSubscription.status?.cancelDate != nil)
        XCTAssert(newSubscription.status?.cancelDate == df.date(from: endDateString))
    }
}
