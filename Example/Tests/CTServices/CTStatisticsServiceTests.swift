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

import RxBlocking

class CTStatisticServiceTests:QuickSpec {
    override func spec() {
        beforeEach {
            self.stub(http(.get, uri: "/user/me"), json(Resolver().getJSONForResource(name: "user"), status: 200))
            let _ = try! CTUserService().fetchCurrentUser().toBlocking().first()
            expect(CTUserService().getActiveUserId()) == 47
        }
        
        describe("fetchAll") {
            it("Succesfully fetches all stats for the bike") {
                self.stub(http(.get, uri: "/bike/152/stats/"), json( Resolver().getJSONListForResource(name: "statisticsResponse"), status: 200))
                let callToTest = try! CTStatisticsService().fetchAll(withBikeId: 152).toBlocking().first()
                if let statisticsResponse = callToTest {
                    expect(statisticsResponse).toNot(beNil())
                } else {
                    expect("it can unwrap") == "did not unwrap"
                }
            }
            
            it("Succesfully fetches hourly stats for the bike") {
                self.stub(http(.get, uri: "/bike/152/stats/"), json(Resolver().getJSONListForResource(name: "statisticsResponse"), status: 200))
                let callToTest = try! CTStatisticsService().fetchAll(withBikeId: 152, after: Date()).toBlocking().first()
                if let statisticsResponse = callToTest {
                    expect(statisticsResponse).toNot(beNil())
                } else {
                    expect("it can unwrap") == "did not unwrap"
                }
            }
            
            it("Handles the error when the timespan is invalid") {
                
            }
            
            it("Handles the error when there's no access for the bike") {
                
            }
        }
    }
}
