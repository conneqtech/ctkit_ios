//
//  CTBikeServiceTests.swift
//  ctkit_Tests
//
//  Created by Gert-Jan Vercauteren on 01/11/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
import ctkit
import Mockingjay
import RxSwift

import RxBlocking

class CTBikeServiceTests: QuickSpec {
    
    
    override func spec () {
        describe("Bike information") {
            it("searches for a bike with a frame number") {
                self.stub(http(.get, uri: "/bike/search"), json([Resolver().getJSONForResource(name: "bike-information")], status: 200))
                let subjectUnderTest = CTBikeService()
                
            
                let response = try! subjectUnderTest.searchUnregisteredBike(withFrameIdentifier: "EN15194").toBlocking().first()
                if let response = response {
                    let bike = response[0]
                    
                    expect(bike.partialIMEI) == "3515640561"
                    expect(bike.frameNumber) == "EN15194"
                    
                    expect(bike.manufacturerDescription) == "Speer Fiets"
                    expect(bike.manufacturerModelName) == ""
                    expect(bike.manufacturerProductionDate) == ""
                    expect(bike.manufacturerSKU) == "9999999"
                }
            }
        }
    }
}
