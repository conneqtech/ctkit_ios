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
        describe("Basics") {
            fit("Can create and encode from model") {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                
                let subjectToTest = CTRideModel(
                    withName: "Test ride",
                    rideType: "other",
                    startDate: formatter.date(from: "2019-01-01T01:00:00+0100")!,
                    endDate: formatter.date(from: "2019-01-01T10:00:00+0100")!
                )
            
                let jsonBytes = try! JSONEncoder().encode(subjectToTest)
                
                // Convert it back to 'dumb' JSON so we can inspect some values
                let jsonData = try! JSONSerialization.jsonObject(with: jsonBytes, options: []) as? [String:Any]
                
                guard
                    let startDate = jsonData!["start_date"] as? String,
                    let endDate = jsonData!["end_date"] as? String,
                    let name = jsonData!["name"] as? String,
                    let rideType = jsonData!["ride_type"] as? String
                else {
                   return expect(true) == false
                }
                
                expect(name) == "Test ride"
                expect(rideType) == "other"
        
                expect(startDate) == "2019-01-01T01:00:00+0100"
                expect(endDate) == "2019-01-01T10:00:00+0100"
            }
        }
    }
}
