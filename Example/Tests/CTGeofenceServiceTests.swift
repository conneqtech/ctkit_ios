//
//  CTGeofenceServiceTests.swift
//  ctkit_Tests
//
//  Created by Daan van der Jagt on 13/10/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
import ctkit
import Mockingjay
import RxBlocking
import RxSwift

class CTGeofenceServiceTests: QuickSpec {
    
    override func spec() {
        describe("Geofence tests") {
            let geofence = ["id": 262,
                        "bike_id": 312,
                        "user_id": 47,
                        "name": "Home",
                        "center": [
                            "lat": 0,
                            "lon": 0
                ],
                        "radius": 500,
                        "active_state": 0,
                        "creation_date": "2018-09-17T09:31:36+0000"
                ] as [String: Any]
        
            
            it("fetches a geofence with id") {
                var jsonResponse:CTResult<CTGeofenceModel, CTBasicError>? = nil
              
                self.stub(uri("/bike/geofence/262"), json(geofence))
                
                let result = try! CTGeofenceService().fetch(withGeofenceId: 262).toBlocking().first()
                jsonResponse = result
                expect(jsonResponse).toEventuallyNot(beNil())

            }
            
            it("creates a new geofence for a bike") {
                var jsonResponse:CTResult<CTGeofenceModel, CTBasicError>? = nil
                self.stub(uri("/bike/312/geofence"), json(geofence))
                
                let result = try! CTGeofenceService().create(withBikeId: 312, name: "geofence", latitude: 46, longitude: 12, radius: 30).toBlocking().first()
                jsonResponse = result
                
                expect(jsonResponse).toEventuallyNot(beNil())
            }
            
            it("fetches a list of geofences for a bike") {
                var jsonResponse:CTResult<[CTGeofenceModel], CTBasicError>? = nil
                let list = [geofence, geofence, geofence]
                self.stub(uri("/bike/geofence"), json(list))
                
                let result = try! CTGeofenceService().fetchAll(withBikeId: 312).toBlocking().first()
                jsonResponse = result
                
                expect(jsonResponse).toEventuallyNot(beNil())
            }
        }
    }
}
