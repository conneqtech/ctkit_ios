//
//  CTDrivingBehaviourReportServiceTests.swift
//  ctkit_Tests
//
//  Created by Gert-Jan Vercauteren on 31/10/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest
import RxBlocking

@testable import ctkit

class CTDrivingBehaviourReportServiceTests: XCTestCase {

    override func setUp() {
        let _ = try! CTUserService().login(email: "paul@conneqtech.com", password: "test").toBlocking().first()!
    }

    override func tearDown() {
        CTUserService().logout()
    }

    func test_drivingReport() {
        let result = try! CTDrivingBehaviourReportService().fetchBikeReport(withBikeId: 1295,
                                                                        from: Date().addingTimeInterval(-96000),
                                                                        till: Date()).toBlocking().first()!

        print(result)
    }

}
