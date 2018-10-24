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
    
    enum result {
        case success
        case failure
    }
    
    
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
                var jsonResponse:CTResult<CTGeofenceModel, CTBasicError>?
                self.stub(uri("/bike/geofence/262"), json(geofence))
                try! CTGeofenceService().fetch(withGeofenceId: 262).toBlocking().first().map { (result:CTResult<CTGeofenceModel, CTBasicError>) in
                    switch result {
                    case .success:
                        jsonResponse = result
                    case .failure(_):
                        jsonResponse = nil
                    }
                }
               
            }
            
            it("creates a new geofence for a bike") {
                var jsonResponse:CTResult<CTGeofenceModel, CTBasicError>?
                self.stub(uri("/bike/312/geofence"), json(geofence))
                
                try! CTGeofenceService().create(withBikeId: 312, name: "geofence", latitude: 46, longitude: 12, radius: 30).toBlocking().first().map { (result:CTResult<CTGeofenceModel, CTBasicError>) in
                    switch result {
                    case .success:
                        jsonResponse = result
                    case .failure(_):
                        jsonResponse = nil
                    }
                }
            }
            
            it("fetches a list of geofences for a bike") {
                var jsonResponse:CTResult<[CTGeofenceModel], CTBasicError>?
                let list = [geofence, geofence, geofence]
                self.stub(uri("/bike/geofence"), json(list))
                
                try! CTGeofenceService().fetchAll(withBikeId: 312).toBlocking().first().map { (result:CTResult<[CTGeofenceModel], CTBasicError>) in
                    switch result {
                    case .success:
                        jsonResponse = result
                    case .failure(_):
                        jsonResponse = nil
                    }
                }
             
            }
        }
    }
}
