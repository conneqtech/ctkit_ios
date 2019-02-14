//
//  CTTheftCaseModelTests.swift
//  ctkit_Tests
//
//  Created by Daan van der Jagt on 10/12/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
import RxSwift
import RxBlocking

@testable import ctkit

class CTTheftCaseModelTests:QuickSpec {
    override func spec() {
        describe("Decoding & Encoding") {
            it("Decodes the API response into the Model") {
                let decodeResult = try! JSONDecoder().decode(CTPaginatableResponse<CTTheftCaseModel>.self, from: Resolver().getDataForResource(name: "theftcase"))
                if let subjectToTest = decodeResult.data.first {
                    expect(subjectToTest.ownerName) == "Kees Teft"
                    expect(subjectToTest.id) == 0
                    expect(subjectToTest.partnerCaseNumber).to(beNil())
                    expect(subjectToTest.caseNumber) == "9rMBB"
                    expect(subjectToTest.policeCaseNumber).to(beNil())
                    expect(subjectToTest.caseStatus) == "reported"
                } else {
                    expect("There's data available") == "no data available"
                }

            }

            it("Encodes into something the API accepts") {
                let decodeResult = try! JSONDecoder().decode(CTPaginatableResponse<CTTheftCaseModel>.self, from: Resolver().getDataForResource(name: "theftcase"))
                if let theftCaseModel = decodeResult.data.first {
                    let jsonBytes = try! JSONEncoder().encode(theftCaseModel)

                    // Convert it back to 'dumb' JSON so we can inspect some values
                    let jsonData = try! JSONSerialization.jsonObject(with: jsonBytes, options: []) as? [String:Any]

                    // Check for non encodings
                    if let _ = jsonData?["id"] {
                        expect("We don't want this") == "encoded"
                    }

                    // Check *all* fields!
                    expect(jsonData!["bike_additional_details"] as? String) == ""
                    expect(jsonData!["bike_color"] as? String) == "Zwart"
                    expect(jsonData!["bike_frame_type"] as? String) == "female"
                    expect(jsonData!["bike_type"] as? String) == "Emulator"
                    expect(jsonData!["bike_images"] as? [String]) == [
                        "https://cb4e5bc7a3dc43969015c331117f69c1.objectstore.eu/cnt/static/sparta-bikeimage-default-m8i.png"
                    ]
                    expect(jsonData!["police_case_number"]).to(beNil())
                    expect(jsonData!["bike_is_insured"] as? Bool) == true

                    expect(jsonData!["owner_address"] as? String) == "Edisonweg 41"
                    expect(jsonData!["owner_city"] as? String) == "Vlissingen"
                    expect(jsonData!["owner_country"] as? String) == "NL"
                    expect(jsonData!["owner_email"] as? String) == "example@conneqtech.com"
                    expect(jsonData!["owner_phone_number"] as? String) == "31612345678"
                    expect(jsonData!["owner_postal_code"] as? String) == "4382NW"
                    expect(jsonData!["owner_name"] as? String) == "Kees Teft"

                    expect(jsonData?.count) == 14

                } else {
                    expect("There's data available") == "no data available"
                }
            }
        }
    }
}
