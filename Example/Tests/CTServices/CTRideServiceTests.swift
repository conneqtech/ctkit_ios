//
//  CTRideServiceTests.swift
//  ctkit_Tests
//
//  Created by Daan van der Jagt on 10/11/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
import ctkit
import Mockingjay
import RxSwift

import RxBlocking
import XCTest

class CTRideServiceTests: XCTestCase {
    
    override func setUp() {
        let _ = try! CTUserService().login(email: "paul@conneqtech.com", password: "test").toBlocking().first()!
    }
}
