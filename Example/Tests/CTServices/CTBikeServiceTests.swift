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
        beforeEach {
            self.stub(http(.get, uri: "/user/me"), json(Resolver().getJSONForResource(name: "user"), status: 200))
            _ = try! CTUserService().fetchCurrentUser().toBlocking().first()
            expect(CTUserService().getActiveUserId()) == 47
        }

        //TODO: Fix this test to use mocked responses
        describe("Linked users") {
            beforeEach {
//                let _ = try! CTUserService().login(email: "paul@conneqtech.com", password: "test").toBlocking().first()
            }

            it("updates the linked users for a bike") {
//                var bike = try! CTBikeService().fetch(withId: 152).toBlocking().first()!
//
//                let linkedUsers = [
//                    CTBasicUserModel(withUsername: "test@connectech.com"),
//                    CTBasicUserModel(withUsername: "gert-jan@connectech.com"),
//                    CTBasicUserModel(withUsername: "jens@connectech.com"),
//                    CTBasicUserModel(withUsername: "nora@connectech.com")
//                ]
//
//                var patchedBike = try! CTBikeService().updateLinkedUsers(withBikeId: bike.id!, andLinkedUsers: linkedUsers).toBlocking().first()!
//
//                expect(patchedBike.linkedUsers.count) == 4
//
//                var patchedBikeRematch = try! CTBikeService().updateLinkedUsers(withBikeId: bike.id!, andLinkedUsers: [linkedUsers.first!]).toBlocking().first()!
//                expect(patchedBikeRematch.linkedUsers.count) == 1
//
//
//                patchedBikeRematch = try! CTBikeService().updateLinkedUsers(withBikeId: bike.id!, andLinkedUsers: []).toBlocking().first()!
//                expect(patchedBikeRematch.linkedUsers.count) == 0
            }
        }

        describe("create") {
            it("Fails to create a bike when it's already registered / unknown") {
                let subjectUnderTest = CTBikeService()
                self.stub(http(.post, uri:"/bike"), json(Resolver().getJSONForResource(name: "bike-registration-failed"), status: 422))
                do {
                    _ = try subjectUnderTest.create(withName: "Test bike", imei: "123456789", activationCode: "EMU12345").toBlocking().first()
                } catch {
                    if let ctError = error as? CTErrorProtocol {
                        expect(ctError.type) == .basic
                        expect(ctError.translationKey) == "error.api.registration.failed"
                    } else {
                        expect("error") == "ctError"
                    }
                }
            }

            it("Creates a bike when it's not already registered / unknown") {
                let subjectUnderTest = CTBikeService()
                self.stub(http(.post, uri:"/bike"), json(Resolver().getJSONForResource(name: "bike-registration-successful"), status: 200))

                let response = try! subjectUnderTest.create(withName: "Test bike", imei: "123456789", activationCode: "EMU12345").toBlocking().first()
                if let unwrappedResponse = response {
                    expect(unwrappedResponse.frameIdentifier) == "EMU8885"
                    expect(unwrappedResponse.imei) == "888888888888885"
                    expect(unwrappedResponse.name) == "TEST BIKE"
                    expect(unwrappedResponse.id) == 152
                    expect(unwrappedResponse.batteryPercentage) == 0

                    //Check last location
                    expect(unwrappedResponse.lastLocation!.latitude).to(beCloseTo(52.2567, within: 0.001))
                    expect(unwrappedResponse.lastLocation!.longitude).to(beCloseTo(5.3760, within: 0.001))
                    expect(unwrappedResponse.lastLocation!.speed) == 6
                    expect(unwrappedResponse.lastLocation!.isMoving) == false
//                    expect(unwrappedResponse.lastLocation!.date) == "2018-11-06T09:45:00+0000"
                    expect(unwrappedResponse.keyIdentifier).to(beNil())
                    expect(unwrappedResponse.themeColor).to(beNil())
                    expect(unwrappedResponse.imageUrl) == "https://cb4e5bc7a3dc43969015c331117f69c1.objectstore.eu/cnt/static/sparta-bikeimage-default-m8i.png"
//                    expect(unwrappedResponse.creationDate) == "2018-11-06T10:04:55+0000"
                    expect(unwrappedResponse.owner?.displayName) == "Paul Jacobse"
                }
            }

            it("Fetches a list of all bikes") {
                self.stub(http(.get, uri: "/bike"), json(Resolver().getJSONListForResource(name: "bike-list"), status: 200))

                let response = try! CTBikeService().fetchAll().toBlocking().first()!

                expect(response.count) == 4
            }

//            it("Fetches a list of bikes we are the owner of") {
//                self.stub(http(.get, uri: "/bike"), json(Resolver().getJSONListForResource(name: "bike-list"), status: 200))
//
//                let response = try! CTBikeService().fetchOwned().toBlocking().first()!
//
//                expect(CTUserService().getActiveUserId()) != -1
//
//                expect(response.count) == 3
//            }

            it("Fetches a list of bikes we have access to, but are not the owner") {
                self.stub(http(.get, uri: "/bike"), json(Resolver().getJSONListForResource(name: "bike-list"), status: 200))

                let response = try! CTBikeService().fetchShared().toBlocking().first()!

                expect(CTUserService().getActiveUserId()) != -1
                expect(response.count) == 1
            }
        }

        describe("patch") {
            it("Patches a bike with CTBikeModel") {
                var bikeJSON = Resolver().getJSONForResource(name: "bike")

                self.stub(http(.get, uri: "/bike/312"), json(bikeJSON, status: 200))
                var subjectToTest = try! CTBikeService().fetch(withId: 312).toBlocking().first()!

                expect(subjectToTest.name) == "Test bike"

                subjectToTest.name = "CHANGED NAME"

                //Set response proper.
                bikeJSON["name"] = "CHANGED NAME"
                self.stub(http(.patch, uri: "/bike/312"), json(bikeJSON, status: 200))

                let patchedBike = try! CTBikeService().patch(withBike: subjectToTest).toBlocking().first()!
                expect(patchedBike.name) == "CHANGED NAME"

            }
        }

        describe("Bike information") {
//            it("searches for a bike with a frame number") {
////                self.stub(http(.get, uri: "/bike/search"), json([Resolver().getJSONForResource(name: "bike-information")], status: 200))
//                let subjectUnderTest = CTBikeService()
//
//                let response = try! subjectUnderTest.searchUnregisteredBike(withFrameIdentifier: "EMU9260").toBlocking().first()
//                if let response = response {
//                    expect(response.count) > 0
//                    let bike = response[0]
//
//                    expect(bike.partialIMEI) == "8888562846"
//                    expect(bike.frameNumber) == "EMU9260"
//
//                    expect(bike.manufacturerSKU) == "9999999"
//                    expect(bike.registrationFlow) == .imei
//                }
//            }
            
//            it("searches for a bike with a frame number but gets 0 results") {
//                self.stub(http(.get, uri: "/bike/search"), json([Resolver().getJSONForResource(name: "bike-information")], status: 200))
//                let subjectUnderTest = CTBikeService()
//                let response = try! subjectUnderTest.searchUnregisteredBike(withFrameIdentifier: "BOGUS").toBlocking().first()
//                if let response = response {
//                    expect(response.count) == 0
//                }
//            }
        }
    }
}
