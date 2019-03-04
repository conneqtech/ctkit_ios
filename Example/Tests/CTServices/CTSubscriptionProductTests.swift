//
//  CTSubscriptionTests.swift
//  ctkit_Tests
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

class CTSubscriptionProductTests: XCTestCase {
    
    func testFetchAll() {
        let products = try! CTSubscriptionProductService().fetchAll().toBlocking().first()!
        XCTAssertEqual(products.count, 1)
    }
    
    func testFetchAllProductType() {
        let products = try! CTSubscriptionProductService().fetchAll(withProductType: .connectivity).toBlocking().first()!
        XCTAssertEqual(products.count, 1)
    }
    
}
