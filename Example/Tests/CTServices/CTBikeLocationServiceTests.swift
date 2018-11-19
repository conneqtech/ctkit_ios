//
//  CTBikeLocationServiceTests.swift
//  ctkit_Tests
//
//  Created by Gert-Jan Vercauteren on 12/11/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
import ctkit
import Mockingjay
import RxSwift

import RxBlocking

class CTBikeLocationServiceTests: QuickSpec {
    
    override func spec() {
        describe("CTBikeLocationServiceTests") {
            describe("Fetch history for a given timeframe") {
                it("Fetches history successfully") {
                    self.stub(everything, json(Resolver().getJSONListForResource(name: "bike-history"), status: 200))
                    
                    let response = try! CTBikeLocationService().fetchHistoryForBike(withId: 112, from: Date(), until: Date()).toBlocking().first()!
                    
                    expect(response.count) == 26
            
                    expect(response[0].latitude).to(beCloseTo(51.446975))
                    expect(response[0].longitude).to(beCloseTo(3.574013))
                    expect(response[0].speed) == 2
                    expect(response[0].batteryPercentage) == 0
                    expect(response[0].isMoving) == false
                }
            }
            
            describe("Fetch last location of bike") {
                it("Fetches last location successfully") {
                    self.stub(http(.get, uri: "/bike/10"), json(Resolver().getJSONForResource(name: "bike"), status: 200))

                    let response = try! CTBikeLocationService().fetchLastLocationOfBike(withId: 10).toBlocking().first()

                    if let r = response {
                        expect(r?.latitude).to(beCloseTo(51.4546))
                        expect(r?.longitude).to(beCloseTo(3.5913))
                        expect(r?.speed) == 0
                        expect(r?.batteryPercentage) == 0
                        expect(r?.isMoving) == false
                    }
                }
                
                it("Returns nil when the bike has no last location") {
                    var nilledJSON = Resolver().getJSONForResource(name: "bike")
                    nilledJSON["last_location"] = nil
                    
                    self.stub(http(.get, uri: "/bike/10"), json(nilledJSON, status: 200))
                    
                    let response = try! CTBikeLocationService().fetchLastLocationOfBike(withId: 10).toBlocking().first()!
                    expect(response).to(beNil())
                }
            }
        }
    }
    
}
