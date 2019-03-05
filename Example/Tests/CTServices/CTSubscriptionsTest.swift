//
//  CTSubscriptionsTest.swift
//  ctkit_Example
//
//  Created by Gert-Jan Vercauteren on 04/03/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import XCTest
import Mockingjay
import RxSwift
import RxBlocking

@testable import ctkit

class CTSubscriptionsTest: XCTestCase {
    
    override func setUp() {
        let _ = try! CTUserService().login(email: "tech+proxible@conneq.tech", password: "Testpass").toBlocking().first()!
    }
    
    func testCreateTrial() {
//        let _ = try! CTUserService().login(email: "tech+proxible@conneq.tech", password: "Testpass").toBlocking().first()!
//        let bikes = try! CTBikeService().fetchAll().toBlocking().first()!
//
//
//        print(bikes)
//
//        let bikeId = 850
//        let imei = "888888888888885"
//
//        let trialResult = try! CTSubscriptionService().startTrial(withBikeId: bikeId, imei: imei).toBlocking().first()!
//        print(trialResult)
    }
    
    func testFetchSubscriptions() {
        let subscriptions = try! CTSubscriptionService().fetchAll(withBikeId: 850).toBlocking().first()!
        print(subscriptions)
    }
}
