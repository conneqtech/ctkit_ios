//
//  CTTheftCasePartnerServiceTests.swift
//  ctkit_Tests
//
//  Created by Gert-Jan Vercauteren on 07/01/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
import ctkit
import Mockingjay
import RxSwift

import RxBlocking
import UIKit

class CTTheftCasePartnerServiceTests :QuickSpec {
    
    override func spec() {
        describe("Fetch all partners") {
            beforeEach {
                let _ = try! CTUserService().login(email: "paul@conneqtech.com", password: "test").toBlocking().first()
            }
            
            it("fetches a list of partners") {
                self.stub(http(.get, uri: "/theft-case-partner"), json( Resolver().getJSONListForResource(name: "fetchAllInsuredPartners"), status: 200))
                let subjectUnderTest = try! CTTheftCasePartnerService().fetchAll(forInsuredBike: true).toBlocking().first()
                
                expect(subjectUnderTest![0].name) == "Test insured partner"
            }
            
            it("fetches a list of uninsured partners") {
                self.stub(http(.get, uri: "/theft-case-partner"), json( Resolver().getJSONListForResource(name: "fetchAllUninsuredPartners"), status: 200))
                let subjectUnderTest = try! CTTheftCasePartnerService().fetchAll(forInsuredBike: false).toBlocking().first()
                
                expect(subjectUnderTest![0].name) == "Test uninsured partner"
            }
        }
    }
}
