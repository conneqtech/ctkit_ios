//
//  CTTheftCasePartnerServiceTests.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 07/01/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation

import Foundation
import Quick
import Nimble
import ctkit
import Mockingjay
import RxSwift

import RxBlocking
import UIKit

class CTTheftCasePartnerServiceTests:QuickSpec {
    
    override func spec () {
        describe("Theftcase partner fetch all") {
            beforeEach {
                let _ = try! CTUserService().login(email: "paul@conneqtech.com", password: "test").toBlocking().first()
            }
            
            it("fetches a list of all recovery partners") {
                let fetchResult = try! CTTheftCasePartnerService().fetchAll().toBlocking().first()
                expect(fetchResult[0].name) = "test"
            }
        }
    }
}
