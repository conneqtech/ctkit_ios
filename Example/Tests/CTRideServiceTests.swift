//
//  CTRideServiceTests.swift
//  ctkit_Tests
//
//  Created by Daan van der Jagt on 23/10/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import RxSwift
import Quick
import Nimble
import RxBlocking
import Mockingjay
import ctkit

class CTRideServiceTests:QuickSpec {
    override func spec() {
        describe("RideService tests") {
            var url = Bundle(for: type(of: self)).url(forResource: "theftcase", withExtension: "json")!
            let rideData = try! Data(contentsOf: url)
            
            url = Bundle(for: type(of: self)).url(forResource: "theftcaseList", withExtension: "json")!
            let rideListData = try! Data(contentsOf: url)
            
            
            
            it("fetches a certain ride") {
                var jsonResponse:CTRideModel?
                self.stub(http(.get, uri: "/bike/ride/262"), json(rideData))
                try! CTRideService().fetch(withRideId: 262).toBlocking().first().map { (result:CTRideModel) in
                    jsonResponse = result
                }
                expect(jsonResponse).toNot(beNil())
            }
            
            it("fetches a list of rides linked to a bike") {
                var jsonResponse:[CTRideModel]?
                self.stub(http(.get, uri:"bike/312/ride"), json(rideListData))
                
                try! CTRideService().fetchAll(withBikeId: 312).toBlocking().first().map { (result:[CTRideModel]) in
                    jsonResponse = result
                }
                expect(jsonResponse).toNot(beNil())
            }
            
            it("creates a new ride for a bike") {
                var jsonResponse:CTRideModel?
                self.stub(http(.post, uri: "bike/312/ride"), json(rideData))

                try! CTRideService().create(withBikeId: 312, startDate: Date(), endDate: Date(), rideType: "ride.type.leisure", name: "ride").toBlocking().first().map { (result:CTRideModel) in
                    jsonResponse = result
                }
                expect(jsonResponse).toNot(beNil())
            }
            
            it("handles the error when the ride is invalid") {
//                self.stub(http(.post, uri: "bike/312/ride"), jsondata())
            }
        }
    }
}
