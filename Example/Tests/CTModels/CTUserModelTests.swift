//
//  CTUserModelTests.swift
//  ctkit_Example
//
//  Created by Gert-Jan Vercauteren on 02/11/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
import RxSwift
import RxBlocking

@testable import ctkit

class CTUserModelTests: QuickSpec {

    override func spec() {
        describe("Decoding & Encoding") {
            it("Decodes the API response into the Model") {
                let subjectToTest = try! JSONDecoder().decode(CTUserModel.self, from: Resolver().getDataForResource(name: "user"))

                expect(subjectToTest.id) == 47
                expect(subjectToTest.houseNumber) == 2
                expect(subjectToTest.street) == "Example road"
                expect(subjectToTest.displayName) == "User Last name"
            }

            it("Returns an empty displayname if first and last name are empty") {
                var subjectToTest = try! JSONDecoder().decode(CTUserModel.self, from: Resolver().getDataForResource(name: "user"))

                expect(subjectToTest.displayName) == "User Last name"

                subjectToTest.firstName = nil
                subjectToTest.lastName = nil

                expect(subjectToTest.displayName) == ""
            }

            it("Encodes into something the API accepts") {
                let subjectToTest = try! JSONDecoder().decode(CTUserModel.self, from: Resolver().getDataForResource(name: "user"))

                let jsonBytes = try! JSONEncoder().encode(subjectToTest)

                // Convert it back to 'dumb' JSON so we can inspect some values
                let jsonData = try! JSONSerialization.jsonObject(with: jsonBytes, options: []) as? [String:Any]

                // Check for non encodings
                if let _ = jsonData?["id"] {
                    expect("We don't want this") == "encoded"
                }

                if let _ = jsonData?["username"] {
                    expect("We don't want this") == "encoded"
                }

                // Check *all* fields!
                expect(jsonData!["first_name"] as? String) == "User"
                expect(jsonData!["last_name"] as? String) == "Last name"
                expect(jsonData!["initials"] as? String) == "G.J."
                expect(jsonData!["gender"] as? String) == "m"
                expect(jsonData!["avatar_url"] as? String) == "https://URL-TO-RESOURCE.com"
                expect(jsonData!["address"] as? String) == "Example road"
                expect(jsonData!["house_number"] as? Int) == 2
                expect(jsonData!["house_number_addition"] as? String) == "34"
                expect(jsonData!["country"] as? String) == "NL"
                expect(jsonData!["postal_code"] as? String) == "4381 WB"

                expect(jsonData?.count) == 13
            }
        }
    }
}
