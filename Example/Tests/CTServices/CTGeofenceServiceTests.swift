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
        beforeEach {
            self.stub(http(.get, uri: "/user/me"), json(Resolver().getJSONForResource(name: "user"), status: 200))
            _ = try! CTUserService().fetchCurrentUser().toBlocking().first()
            expect(CTUserService().getActiveUserId()) == 47
        }

        describe("fetch") {
            describe("fetchwithgeofenceid") {
                it("Handles the error when the geofence doesn't exist") {
                    self.stub(http(.get, uri: "/bike/geofence/0"), json(Resolver().getJSONForResource(name: "geofenceIdNotFound"), status: 404))

                    do {
                        try _ = CTGeofenceService().fetch(withGeofenceId: 0).toBlocking().first()
                    } catch {
                        if let ctError = error as? CTErrorProtocol {
                            expect(ctError.type) == .basic
                            expect(ctError.translationKey) == "api.error.404.not-found"
                        } else {
                            expect("error") == "ctError"
                        }
                    }
                }

                it("Succesfully fetches a geofence") {
                    self.stub(http(.get, uri: "/bike/geofence/262"), json(Resolver().getJSONForResource(name: "geofence"), status: 200))
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
                    self.stub(http(.get, uri: "/bike/0/geofence"), json(Resolver().getJSONForResource(name: "bikeIdNotFound"), status: 404))
                    do {
                        try _ = CTGeofenceService().fetchAll(withBikeId: 0).toBlocking().first()
                    } catch {
                        if let ctError = error as? CTErrorProtocol {
                            expect(ctError.type) == .basic
                            expect(ctError.translationKey) == "api.error.404.not-found"
                        } else {
                            expect("error") == "ctError"
                        }
                    }
                }

                it("Fetches all geofences for the given bike") {
                    self.stub(http(.get, uri: "/bike/152/geofence"), json(Resolver().getJSONListForResource(name: "geofenceList"), status: 200))
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
                    self.stub(http(.post, uri: "/bike/152/geofence"), json(Resolver().getJSONForResource(name: "createGeofenceValidationError"), status: 422))
                    do {
                        try _ = CTGeofenceService().create(withBikeId: 152, name: "INVALIDGEOFENCENAME", latitude: 0, longitude: 0, radius: 0).toBlocking().first()
                    } catch {
                        if let ctError = error as? CTErrorProtocol {
                            expect(ctError.type) == .validation
                            expect(ctError.translationKey) == "api.error.validation-failed"

                            if let validationError = ctError as? CTValidationError {
                                expect(validationError.validationMessages).to(haveCount(4))
                                //TODO: Check actual messages
                            }
                        } else {
                            expect("error") == "ctError"
                        }
                    }
                }

                it("Succesfully creates a new geofence and returns it") {
                    self.stub(http(.post, uri: "/bike/152/geofence"), json(Resolver().getJSONForResource(name: "geofence"), status: 200))
                    let callToTest = try! CTGeofenceService().create(withBikeId: 152, name: "VALIDNAME", latitude: 34, longitude: 60, radius: 12).toBlocking().first()

                    if let geofence = callToTest {
                        expect(geofence.bikeId).to(equal(312))
                    } else {
                        expect("can unwrap") == "did not unwrap"
                    }
                }
            }

            describe("patch") {
                it("Handles the error when the value is not accepted") {
                    var updatedGeofence = Resolver().getJSONForResource(name: "geofence")
                    updatedGeofence["user_id"] = 0
                    updatedGeofence["radius"] = 0
                    updatedGeofence["name"] = ""

                    do {
                        let updatedGeofenceModel = try JSONSerialization.data(withJSONObject: updatedGeofence, options: JSONSerialization.WritingOptions.prettyPrinted)

                        self.stub(http(.patch, uri: "/bike/geofence/262"), json(Resolver().getJSONForResource(name: "createGeofenceValidationError"), status: 422))
                        do {
                            _ = try CTGeofenceService().patch(geofence: JSONDecoder().decode(CTGeofenceModel.self, from: updatedGeofenceModel)).toBlocking().first()
                        } catch {
                            if let ctError = error as? CTErrorProtocol {
                                expect(ctError.type) == .validation
                                expect(ctError.translationKey) == "api.error.validation-failed"

                                if let validationError = ctError as? CTValidationError {
                                    expect(validationError.validationMessages).to(haveCount(4))

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

                it("Succesfully patches an existing geofence") {
                    let originalGeofenceModel = try! JSONDecoder().decode(CTGeofenceModel.self, from: Resolver().getDataForResource(name: "geofence"))
                    var updatedGeofenceModel = Resolver().getJSONForResource(name: "geofence")
                    updatedGeofenceModel["name"] = "PATCHED_NAME"

                    self.stub(http(.patch, uri: "/bike/geofence/262"), json(updatedGeofenceModel))
                    let callToTest = try! CTGeofenceService().patch(geofence: originalGeofenceModel).toBlocking().first()
                    if let updatedGeofence = callToTest {
                        expect(updatedGeofence.name).to(equal("PATCHED_NAME"))
                    } else {
                        expect("can unwrap") == "did not unwrap"
                    }
                }
            }

            describe("delete") {
                it("Handles the error when the geofence doesn't exist") {
                    self.stub(http(.patch, uri: "/bike/geofence/0"), json(Resolver().getJSONForResource(name: "geofenceIdNotFound"), status: 404))

                    do {
                        _ = try CTGeofenceService().delete(withGeofenceId: 0).toBlocking().first()
                    } catch {
                        if let ctError = error as? CTErrorProtocol {
                            expect(ctError.type) == .basic
                            expect(ctError.translationKey) == "api.error.404.not-found"
                        } else {
                            expect("error") == "ctError"
                        }
                    }
                }

//                it("Succesfully archives the geofence") {
//                    let originalGeofenceModel = try! JSONDecoder().decode(CTGeofenceModel.self, from: Resolver().getDataForResource(name: "geofence"))
//                    var updatedGeofenceModel = Resolver().getJSONForResource(name: "geofence")
//                    updatedGeofenceModel["active_state"] = 2
//
//                    self.stub(http(.patch, uri: "/bike/geofence/262"), json(updatedGeofenceModel))
//
//                    let callToTest = try! CTGeofenceService().delete(withGeofenceId: 262).toBlocking().first()
//                    expect(callToTest).to(beNil())
//                }
            }
        }
    }
}
