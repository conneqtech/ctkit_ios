//
//  CTGeofenceServiceTests.swift
//  ctkit_Tests
//
//  Created by Daan van der Jagt on 08/11/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
import ctkit
import Mockingjay
import RxSwift

import RxBlocking

class CTGeofenceServiceTests: QuickSpec {
    let bag = DisposeBag()
    
    override func spec() {
        describe("fetch") {
            beforeEach {
                let _ = try! CTUserService().login(email: "paul@conneqtech.com", password: "test").toBlocking().first()
            }
            
            describe("fetchwithgeofenceid") {
                it("Handles the error when the geofence doesn't exist") {
                    self.stub(http(.get, uri: "/bike/geofence/0"), json(Resolver().getJSONForResource(name: "geofenceIdNotFound"), status: 404))
                    
                    do {
                       try _ = CTGeofenceService().fetch(withGeofenceId: 0).toBlocking().first()
                    } catch {
                        if let ctError = error as? CTErrorProtocol {
                            expect(ctError.type) == .basic
                            expect(ctError.translationKey) == "error.api.not-found"
                        } else {
                            expect("error") == "ctError"
                        }
                    }
                }
                
                it("Succesfully fetches a geofence") {
                    self.stub(http(.get, uri: "bike/geofence/262"), json(Resolver().getJSONForResource(name: "geofenceList"), status: 200))
                    let callToTest = try! CTGeofenceService().fetch(withGeofenceId: 262).toBlocking().first()
                    
                    if let geofence = callToTest {
                        expect(geofence.id).to(equal(262))
                    } else {
                        expect("can unwrap") == "did not unwrap"
                    }
                }
            }
    
            describe("fetchgeofencesforbike") {
                it("Handles the error when the bikeId doesn't exist") {
                    self.stub(http(.get, uri: "bike/0/geofence/"), json(Resolver().getJSONForResource(name: "bikeIdNotFound"), status: 404))
                    do {
                        try _ = CTGeofenceService().fetchAll(withBikeId: 0).toBlocking().first()
                    } catch {
                        if let ctError = error as? CTErrorProtocol {
                            expect(ctError.type) == .basic
                            expect(ctError.translationKey) == "error.api.not-found"
                        } else {
                            expect("error") == "ctError"
                        }
                    }
                }
                
                it("Fetches all geofences for the given bike") {
                    self.stub(http(.get, uri: "bike/152/geofence/"), json(Resolver().getJSONForResource(name: "geofenceList"), status: 200))
                    let callToTest = try! CTGeofenceService().fetchAll(withBikeId: 152).toBlocking().first()
                    
                    if let geofenceList = callToTest {
                        expect(geofenceList.count).to(beGreaterThan(0))
                    } else {
                        expect("can unwrap") == "did not unwrap"
                    }
                }
            }
            
            describe("create") {
                it("Handles the error when one or more fields are incorrect") {
                    self.stub(http(.post, uri: "bike/152/geofence"), json(Resolver().getJSONForResource(name: "createGeofenceValidationError"), status: 422))
                    do {
                        try _ = CTGeofenceService().create(withBikeId: 0, name: "INVALIDGEOFENCENAME", latitude: 0, longitude: 0, radius: 0).toBlocking().first()
                    } catch {
                        if let ctError = error as? CTErrorProtocol {
                            expect(ctError.type) == .validation
                            expect(ctError.translationKey) == "api.error.validation-failed"
                            
                            if let validationError = ctError as? CTValidationError {
                                expect(validationError.validationMessages).to(haveCount(1))
                                
                                let messageToTest = validationError.validationMessages[0]
                                expect(messageToTest.type) == "usernameAlreadyTaken"
                                expect(messageToTest.originalMessage) == "User already exists"

                            }
                        }
                    }
                }
                
                it("Succesfully creates a new geofence and returns it") {
                    self.stub(http(.post, uri: "bike/152/geofence"), json(Resolver().getJSONForResource(name: "geofence"), status: 200))
                    let callToTest = try! CTGeofenceService().create(withBikeId: 152, name: "VALIDNAME", latitude: 34, longitude: 60, radius: 12).toBlocking().first()
                    
                    if let geofence = callToTest {
                        expect(geofence.bikeId).to(equal(152))
                    } else {
                        expect("can unwrap") == "did not unwrap"
                    }
                }
            }
            
            describe("patch") {
                it("Handles the error when the entity ") {
                    
                }
            }
        }
    }
}
