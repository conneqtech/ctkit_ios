//
//  CTRideModelTests.swift
//  ctkit_Tests
//
//  Created by Daan van der Jagt on 08/12/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
import RxSwift
import RxBlocking

@testable import ctkit

class CTRideModelTests:QuickSpec {
    override func spec() {
        describe("Decoding & Encoding") {
//            it("Decodes the API response into the Model") {
//                let subjectToTest = try! JSONDecoder().decode(CTRideModel.self, from: Resolver().getDataForResource(name: "ride"))
//                expect(subjectToTest.id) == 92
//                expect(subjectToTest.bikeId) == 0
//                expect(subjectToTest.userId) == 4
////                expect(subjectToTest.creationDate) == "2018-09-17T13:09:02+0000"
//                expect(subjectToTest.calories) == 27
//                expect(subjectToTest.averageSpeed) == 11
//                expect(subjectToTest.distanceTraveled) == 857
//                expect(subjectToTest.co2) == 128
//
//            }
//
//            it("Encodes into something the API accepts") {
//                let subjectToTest = try! JSONDecoder().decode(CTRideModel.self, from: Resolver().getDataForResource(name: "ride"))
//
//                let jsonBytes = try! JSONEncoder().encode(subjectToTest)
//
//                // Convert it back to 'dumb' JSON so we can inspect some values
//                let jsonData = try! JSONSerialization.jsonObject(with: jsonBytes, options: []) as? [String:Any]
//
//                // Check for non encodings
//                if let _ = jsonData?["id"] {
//                    expect("We don't want this") == "encoded"
//                }
//
//                if let _ = jsonData?["creation_date"] {
//                    expect("We don't want this") == "encoded"
//                }
//
//                // Check *all* fields!
//
//                expect(jsonData!["name"] as? String) == "Vrijetijdsrit"
//                expect(jsonData!["start_date"] as? String) == "2018-09-13T01:40:00+0000"
//                expect(jsonData!["end_date"] as? String) == "2018-09-13T01:45:30+0000"
//                expect(jsonData!["ride_type"] as? String) == "ride.type.leisure"
//
//                expect(jsonData?.count) == 4
//            }
        }
    }
}
