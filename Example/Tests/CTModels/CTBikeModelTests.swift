//
//  CTBikeModelTests.swift
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


class CTBikeModelTests:QuickSpec {
    override func spec() {
        describe("Decoding & Encoding") {
            it("Decodes the API response into the Model") {
                let subjectToTest = try! JSONDecoder().decode(CTBikeModel.self, from: Resolver().getDataForResource(name: "bike"))
                expect(subjectToTest.name) == "Test bike"
                expect(subjectToTest.id) == 312
                expect(subjectToTest.imei) == "351564056082902"
      
            }
            
            
            it("Encodes into something the API accepts") {
                let subjectToTest = try! JSONDecoder().decode(CTBikeModel.self, from: Resolver().getDataForResource(name: "bike"))
                
                let jsonBytes = try! JSONEncoder().encode(subjectToTest)
                
                // Convert it back to 'dumb' JSON so we can inspect some values
                let jsonData = try! JSONSerialization.jsonObject(with: jsonBytes, options: []) as? [String:Any]
                
                // Check for non encodings
                if let _ = jsonData?["id"] {
                    expect("We don't want this") == "encoded"
                }
                
                // Check *all* fields!
                
                expect(jsonData!["name"] as? String) == "Test bike"
                expect(jsonData!["color_hex"]).to(beNil())
                expect(jsonData!["bike_image_url"] as? String) == "https://cb4e5bc7a3dc43969015c331117f69c1.objectstore.eu/cnt/static/sparta-bikeimage-default-m8i.png"
                expect(jsonData!["key_number"] as? String) == "1234A"
                expect(jsonData!["frame_number"] as? String) == "sp1000030"
                expect(jsonData!["is_stolen"] as? Bool) == false
                
       
                expect(jsonData?.count) == 6
            }
        }
    }
}
