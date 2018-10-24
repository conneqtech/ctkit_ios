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

            var url = Bundle(for: type(of: self)).url(forResource: "geofence", withExtension: "json")!
            let geofenceData = try! Data(contentsOf: url)
            
            url = Bundle(for: type(of: self)).url(forResource: "geofenceList", withExtension: "json")!
            let geofenceListData = try! Data(contentsOf: url)

            
            it("fetches a geofence with id") {
                var jsonResponse:CTResult<CTGeofenceModel, CTBasicError>?
                self.stub(http(.get, uri: "/bike/geofence/262"), jsonData(geofenceData))
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
                self.stub(http(.post, uri: ("/bike/312/geofence")), jsonData(geofenceData))

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
                self.stub(http(.get,uri: ("/bike/geofence")), json(geofenceListData))
                
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
