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
            let _ = try! CTUserService().login(email: "paul@conneqtech.com", password: "test").toBlocking().first()
        }
        
        describe("fetchwithrideid") {
            it("Handles the error when the ride doesn't exist") {
                self.stub(http(.get, uri: "bike/ride/0"), json(Resolver().getJSONForResource(name: "rideIdNotFound"), status: 404))
                
                do {
                    try _ = CTRideService().fetch(withRideId: 0).toBlocking().first()
                } catch {
                    if let ctError = error as? CTErrorProtocol {
                        expect(ctError.type) == .basic
                        expect(ctError.translationKey) == "error.api.not-found"
                    } else {
                        expect("error") == "ctError"
                    }
                }
            }
            
            it("Succesfully fetches a ride") {
                self.stub(http(.get, uri: "bike/ride/92"), json(Resolver().getJSONForResource(name: "ride"), status: 200))
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
                self.stub(http(.get, uri: "bike/0/ride/"), json(Resolver().getJSONForResource(name: "rideIdNotFound"), status: 404))
                
                do {
                    try _ = CTRideService().fetchAll(withBikeId: 0).toBlocking().first()
                } catch {
                    if let ctError = error as? CTErrorProtocol {
                        expect(ctError.type) == .basic
                        expect(ctError.translationKey) == "error.api.not-found"
                    } else {
                        expect("error") == "ctError"
                    }
                }
            }
            
            it("Succesfully fetches a list of all rides") {
                self.stub(http(.get, uri: "bike/152/ride"), json(Resolver().getJSONForResource(name: "rideList"), status: 200))
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
                self.stub(http(.post, uri: "bike/0/ride"), json(Resolver().getJSONForResource(name: "createRideValidationError"), status: 422))
                do {
                    try _ = CTGeofenceService().create(withBikeId: 0, name: "INVALIDRIDENAME", latitude: 0, longitude: 0, radius: 0).toBlocking().first()
                } catch {
                    if let ctError = error as? CTErrorProtocol {
                        expect(ctError.type) == .validation
                        expect(ctError.translationKey) == "api.error.validation-failed"
                        
                        if let validationError = ctError as? CTValidationError {
                            expect(validationError.validationMessages).to(haveCount(1))
                            
                            let messageToTest = validationError.validationMessages[0]
                            expect(messageToTest.type) == "validationError"
                            expect(messageToTest.originalMessage) == "One or more fields have not been filled out correctly"
                            
                        }
                    }
                }
            }
            
            it("Succesfully creates a ride") {
                self.stub(http(.post, uri: "bike/152/ride"), json(Resolver().getJSONForResource(name: "ride"), status: 200))
                let callToTest = try! CTRideService().create(withBikeId: 152, startDate: Date(), endDate: Date(), rideType: "ride.type.other", name: "AVALIDRIDENAME").toBlocking().first()
                if let ride = callToTest {
                    expect(ride.bikeId).to(equal(152))
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
                    
                    self.stub(http(.post, uri: "bike/geofence/262"), json(Resolver().getJSONForResource(name: "createRideValidationError"), status: 422))
                    do {
                        _ = try CTRideService().patch(ride: JSONDecoder().decode(CTRideModel.self, from: updatedRideModel)).toBlocking().first()
                    } catch {
                        if let ctError = error as? CTErrorProtocol {
                            expect(ctError.type) == .validation
                            expect(ctError.translationKey) == "api.error.validation-failed"
                            
                            //TODO: change to appropriate error
                            if let validationError = ctError as? CTValidationError {
                                expect(validationError.validationMessages).to(haveCount(1))
                                
                                let messageToTest = validationError.validationMessages[0]
                                expect(messageToTest.type) == "usernameAlreadyTaken"
                                expect(messageToTest.originalMessage) == "User already exists"
                            }
                        }
                    }
                } catch {
                    expect("can get data from jsonobject") == "did not get data out of jsonobject"
                }
            }
            
            it("Succesfully patches an existing geofence") {
                let originalGeofenceModel = try! JSONDecoder().decode(CTGeofenceModel.self, from: Resolver().getDataForResource(name: "geofence"))
                var updatedGeofenceModel = Resolver().getJSONForResource(name: "geofence")
                updatedGeofenceModel["name"] = ""
                
                self.stub(http(.post, uri: "bike/geofence/262"), json(updatedGeofenceModel))
                let callToTest = try! CTGeofenceService().patch(geofence: originalGeofenceModel).toBlocking().first()
                if let updatedGeofence = callToTest {
                    expect(updatedGeofence.name).to(equal("PATCHED_NAME"))
                } else {
                    expect("can unwrap") == "did not unwrap"
                }
            }
        }
        
    }
}
