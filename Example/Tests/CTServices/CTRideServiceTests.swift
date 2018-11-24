//
//  CTRideServiceTests.swift
//  ctkit_Tests
//
//  Created by Daan van der Jagt on 10/11/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
import ctkit
import Mockingjay
import RxSwift

import RxBlocking

class CTRideServiceTests: QuickSpec {
    override func spec() {
        beforeEach {
            self.stub(http(.get, uri: "/user/me"), json(Resolver().getJSONForResource(name: "user"), status: 200))
            let _ = try! CTUserService().fetchCurrentUser().toBlocking().first()
            expect(CTUserService().getActiveUserId()) == 47
        }
        
        describe("fetchwithrideid") {
            it("Handles the error when the ride doesn't exist") {
                self.stub(http(.get, uri: "/bike/ride/0"), json(Resolver().getJSONForResource(name: "rideIdNotFound"), status: 404))
                
                do {
                    _ = try CTRideService().fetch(withRideId: 0).toBlocking().first()
                } catch {
                    if let ctError = error as? CTErrorProtocol {
                        expect(ctError.type) == .basic
                        expect(ctError.translationKey) == "api.error.404.not-found"
                    } else {
                        expect("error") == "ctError"
                    }
                }
            }
            
            it("Succesfully fetches a ride") {
                self.stub(http(.get, uri: "/bike/ride/92"), json(Resolver().getJSONForResource(name: "ride"), status: 200))
                let callToTest = try! CTRideService().fetch(withRideId: 92).toBlocking().first()
                if let ride = callToTest {
                    expect(ride.id).to(equal(92))
                } else {
                    expect("can unwrap") == "did not unwrap"
                }
            }
        }
        
        describe("fetchwithbikeid") {
            it("Handles the error when the bike has no rides") {
                self.stub(http(.get, uri: "/bike/152/ride"), json(Resolver().getJSONForResource(name: "rideIdNotFound"), status: 404))
                
                do {
                    try _ = CTRideService().fetchAll(withBikeId: 152).toBlocking().first()
                } catch {
                    if let ctError = error as? CTErrorProtocol {
                        expect(ctError.type) == .basic
                        expect(ctError.translationKey) == "api.error.404.not-found"
                    } else {
                        expect("error") == "ctError"
                    }
                }
            }
            
            it("Succesfully fetches a list of all rides") {
                self.stub(http(.get, uri: "/bike/152/ride"), json(Resolver().getJSONListForResource(name: "ride-list"), status: 200))
                let callToTest = try! CTRideService().fetchAll(withBikeId: 152).toBlocking().first()
                if let rides = callToTest {
                    expect(rides.count).to(beGreaterThan(0))
                } else {
                    expect("can unwrap") == "did not unwrap"
                }
            }
        }
        
        describe("create") {
            it("Handles the error when one or more fields are incorrect") {
                self.stub(http(.post, uri: "/bike/0/ride"), json(Resolver().getJSONForResource(name: "createRideValidationError"), status: 422))
                do {
                    _ = try CTRideService().create(withBikeId: 0, startDate: Date(), endDate: Date(), rideType: "ride.type.other", name: "INVALIDNAME").toBlocking().first()
                } catch {
                    if let ctError = error as? CTErrorProtocol {
                        expect(ctError.type) == .validation
                        expect(ctError.translationKey) == "api.error.validation-failed"
                        
                        if let validationError = ctError as? CTValidationError {
                            expect(validationError.validationMessages).to(haveCount(6))
                            
                            let messageToTest = validationError.validationMessages[0]
                            expect(messageToTest.type) == "isEmpty"
                            expect(messageToTest.originalMessage) == "Value is required and can't be empty"
                            
                        }
                    }
                }
            }
            
            it("Succesfully creates a ride") {
                self.stub(http(.post, uri: "/bike/152/ride"), json(Resolver().getJSONForResource(name: "ride"), status: 201))
                let callToTest = try! CTRideService().create(withBikeId: 152, startDate: Date(), endDate: Date(), rideType: "ride.type.other", name: "VALIDRIDENAME").toBlocking().first()
                if let ride = callToTest {
                    expect(ride.id).to(equal(92))
                } else {
                    expect("can unwrap") == "did not unwrap"
                }
            }
        }
        
        describe("patch") {
            it("Handles the error when the value is not accepted") {
                var updatedRide = Resolver().getJSONForResource(name: "ride")
                updatedRide["name"] = "SOMEINVALIDNAME"
                updatedRide["ride_type"] = "INVALIDRIDETYPE"
                
                do {
                    let updatedRideModel = try JSONSerialization.data(withJSONObject: updatedRide, options: JSONSerialization.WritingOptions.prettyPrinted)
                    
                    self.stub(http(.patch, uri: "/bike/ride/92"), json(Resolver().getJSONForResource(name: "createRideValidationError"), status: 422))
                    do {
                        _ = try CTRideService().patch(ride: JSONDecoder().decode(CTRideModel.self, from: updatedRideModel)).toBlocking().first()
                    } catch {
                        if let ctError = error as? CTErrorProtocol {
                            expect(ctError.type) == .validation
                            expect(ctError.translationKey) == "api.error.validation-failed"
                            
                            if let validationError = ctError as? CTValidationError {
                                expect(validationError.validationMessages).to(haveCount(6))
                                
                                let messageToTest = validationError.validationMessages[0]
                                expect(messageToTest.type) == "isEmpty"
                                expect(messageToTest.originalMessage) == "Value is required and can't be empty"
                            }
                        }
                    }
                } catch {
                    expect("can get data from jsonobject") == "did not get data out of jsonobject"
                }
            }
            
            it("Succesfully patches an existing ride") {
                let originalRideModel = try! JSONDecoder().decode(CTRideModel.self, from: Resolver().getDataForResource(name: "ride"))
                var updatedRideModel = Resolver().getJSONForResource(name: "ride")
                updatedRideModel["name"] = "PATCHED_NAME"
                
                self.stub(http(.patch, uri: "/bike/ride/92"), json(updatedRideModel))
                let callToTest = try! CTRideService().patch(ride: originalRideModel).toBlocking().first()
                if let updatedRide = callToTest {
                    expect(updatedRide.name).to(equal("PATCHED_NAME"))
                } else {
                    expect("can unwrap") == "did not unwrap"
                }
            }
        }
        
        describe("delete") {
            it("Handles the error when the ride doesn't exist") {
                self.stub(http(.patch, uri: "/bike/ride/0"), json(Resolver().getJSONForResource(name: "rideIdNotFound"), status: 404))
                
                do {
                    _ = try CTRideService().delete(withRideId: 0).toBlocking().first()
                } catch {
                    if let ctError = error as? CTErrorProtocol {
                        expect(ctError.type) == .basic
                        expect(ctError.translationKey) == "api.error.404.not-found"
                    } else {
                        expect("error") == "ctError"
                    }
                }
            }
            
            it("Succesfully archives the ride") {
                self.stub(http(.patch, uri: "/bike/ride/262"), json("", status: 200))
                
                let callToTest = try! CTRideService().delete(withRideId: 262).toBlocking().first()
                if let updatedRide = callToTest {
                    //TODO: Check whether this idea is correct?
                    //Completable seems to returns a Never type with nothing in it
                    expect(updatedRide).to(be(type(of: Never.self)))
                } else {
                    expect("It can unwrap") == ("did not unwrap")
                }
                
            }
        }
        
    }
}
